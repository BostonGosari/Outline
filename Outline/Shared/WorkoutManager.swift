//
//  WorkoutManager.swift
//  Outline
//
//  Created by hyunjun on 11/8/23.
//

import Foundation
import HealthKit
import CoreLocation

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
            print("error to end workout")
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
        #else
        contextDate = nil
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
        }
    }
}

extension WorkoutManager {
    func updateForStatistics(_ statistics: HKStatistics) {
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            
        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            let energyUnit = HKUnit.kilocalorie()
            calorie = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            
        case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKQuantityType.quantityType(forIdentifier: .distanceCycling):
            let meterUnit = HKUnit.meter()
            distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            
        case HKQuantityType(.runningSpeed):
            let kilometerPerSecondUnit = HKUnit.meterUnit(with: .kilo).unitDivided(by: HKUnit.second())
            let speed = statistics.mostRecentQuantity()?.doubleValue(for: kilometerPerSecondUnit) ?? 0
            let averageSpeed = statistics.averageQuantity()?.doubleValue(for: kilometerPerSecondUnit) ?? 0
            pace = calculatePaceFromSpeed(speed: speed)
            averagePace = calculatePaceFromSpeed(speed: averageSpeed)
            
        case HKQuantityType(.cyclingCadence):
            let cadenceUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            cadence = statistics.sumQuantity()?.doubleValue(for: cadenceUnit) ?? 0
            
        default:
            return
        }
    }
    
    func calculatePaceFromSpeed(speed: Double) -> Double {
        if speed > 0 {
            let pace = 1 / speed
            return pace
        } else {
            return 0
        }
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            let sessionSateChange = SessionStateChange(newState: toState, date: date)
            self.asynStreamTuple.continuation.yield(sessionSateChange)
        }
    }
        
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("workout session error")
    }
    
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession, didDisconnectFromRemoteDeviceWithError error: Error?) {
        print("error to connect remote device")
    }
    
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession, didReceiveDataFromRemoteWorkoutSession data: [Data]) {
        Task { @MainActor in
            do {
                for anElement in data {
                    try handleReceivedData(anElement)
                }
            } catch {
                print("error to handle received data")
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
