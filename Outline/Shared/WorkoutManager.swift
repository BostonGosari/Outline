//
//  WorkoutManager.swift
//  Outline
//
//  Created by hyunjun on 11/8/23.
//

import Foundation
import os
import HealthKit

@MainActor
class WorkoutManager: NSObject, ObservableObject {
    struct SessionStateChange {
        let newState: HKWorkoutSessionState
        let date: Date
    }

    @Published var sessionState: HKWorkoutSessionState = .notStarted
    @Published var distance: Double = 0
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var calorie: Double = 0
    @Published var pace: Double = 0
    @Published var averagePace: Double = 0
    @Published var stepCount: Double = 0
    @Published var cadence: Double = 0
    @Published var elapsedTimeInterval: TimeInterval = 0
    
    @Published var workout: HKWorkout?

    let typesToShare: Set = [
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.cyclingCadence),
        HKQuantityType(.stepCount),
        HKQuantityType(.runningSpeed),
        HKQuantityType.workoutType()
    ]
    
    let typesToRead: Set = [
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.cyclingCadence),
        HKQuantityType(.stepCount),
        HKQuantityType(.runningSpeed),
        HKQuantityType.workoutType(),
        HKObjectType.activitySummaryType()
    ]
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    #if os(watchOS)
    var builder: HKLiveWorkoutBuilder?
    #else
    var contextDate: Date?
    #endif

    let asynStreamTuple = AsyncStream.makeStream(of: SessionStateChange.self, bufferingPolicy: .bufferingNewest(1))

    static let shared = WorkoutManager()
    
    private override init() {
        super.init()
        Task {
            for await value in asynStreamTuple.stream {
                await consumeSessionStateChange(value)
            }
        }
    }

    private func consumeSessionStateChange(_ change: SessionStateChange) async {
        sessionState = change.newState
        #if os(watchOS)
        let elapsedTimeInterval = session?.associatedWorkoutBuilder().elapsedTime(at: change.date) ?? 0
        let elapsedTime = WorkoutElapsedTime(timeInterval: elapsedTimeInterval, date: change.date)
        if let elapsedTimeData = try? JSONEncoder().encode(elapsedTime) {
            await sendData(elapsedTimeData)
        }

        guard change.newState == .stopped, let builder else {
            return
        }

        let finishedWorkout: HKWorkout?
        do {
            try await builder.endCollection(at: change.date)
            finishedWorkout = try await builder.finishWorkout()
            session?.end()
        } catch {
            Logger.shared.log("Failed to end workout: \(error))")
            return
        }
        workout = finishedWorkout
        #endif
    }
}

extension WorkoutManager {
    func resetWorkout() {
        #if os(watchOS)
        builder = nil
        #endif
        workout = nil
        session = nil
        distance = 0
        averageHeartRate = 0
        heartRate = 0
        calorie = 0
        pace = 0
        averagePace = 0
        stepCount = 0
        cadence = 0
        elapsedTimeInterval = 0
        sessionState = .notStarted
    }
    
    func sendData(_ data: Data) async {
        do {
            try await session?.sendToRemoteWorkoutSession(data: data)
        } catch {
            Logger.shared.log("Failed to send data: \(error)")
        }
    }
}

extension WorkoutManager {
    func updateForStatistics(_ statistics: HKStatistics) {
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            
        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            let energyUnit = HKUnit.kilocalorie()
            calorie = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            
        case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKQuantityType.quantityType(forIdentifier: .distanceCycling):
            let meterUnit = HKUnit.meter()
            distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            calculateAveragePace(distance: distance, duration: elapsedTimeInterval)
            
        case HKQuantityType(.runningSpeed):
            let meterPerSecondUnit = HKUnit.meter().unitDivided(by: HKUnit.second())
            let speed = statistics.mostRecentQuantity()?.doubleValue(for: meterPerSecondUnit) ?? 0
            calculatePaceFromSpeed(speed: speed)
            
        case HKQuantityType(.cyclingCadence):
            let cadenceUnit = HKUnit.count().unitDivided(by: .minute())
            cadence = statistics.mostRecentQuantity()?.doubleValue(for: cadenceUnit) ?? 0
            
        default:
            return
        }
    }
    
    func calculateAveragePace(distance: Double, duration: TimeInterval) {
        if distance > 0 && duration > 0 {
            let averagePaceInSecondsPerKilometer = duration / distance * 1000
            self.averagePace = averagePaceInSecondsPerKilometer
        } else {
            self.averagePace = 0
        }
    }
    
    func calculatePaceFromSpeed(speed: Double) {
        if speed > 0 {
            let pace = 1 / speed * 1000
            self.pace = pace
        } else {
            self.pace = 0
        }
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didChangeTo toState: HKWorkoutSessionState,
                                    from fromState: HKWorkoutSessionState,
                                    date: Date) {
        Logger.shared.log("Session state changed from \(fromState.rawValue) to \(toState.rawValue)")
        let sessionSateChange = SessionStateChange(newState: toState, date: date)
        asynStreamTuple.continuation.yield(sessionSateChange)
    }
        
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didFailWithError error: Error) {
        Logger.shared.log("\(#function): \(error)")
    }
    
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didDisconnectFromRemoteDeviceWithError error: Error?) {
        Logger.shared.log("\(#function): \(error)")
    }
    
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didReceiveDataFromRemoteWorkoutSession data: [Data]) {
        Logger.shared.log("\(#function): \(data.debugDescription)")
        Task { @MainActor in
            do {
                for anElement in data {
                    try handleReceivedData(anElement)
                }
            } catch {
                Logger.shared.log("Failed to handle received data: \(error))")
            }
        }
    }
}

struct WorkoutElapsedTime: Codable {
    var timeInterval: TimeInterval
    var date: Date
}

extension HKWorkoutSessionState {
    var isActive: Bool {
        self != .notStarted && self != .ended
    }
}
