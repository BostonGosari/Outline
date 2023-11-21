//
//  WorkoutManager.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import Foundation
import HealthKit

class WatchWorkoutManager: NSObject, ObservableObject {
    static let shared = WatchWorkoutManager()
    
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    var isHealthKitAuthorized: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    @Published var showSummaryView = false
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }
        
        session?.delegate = self
        builder?.delegate = self
        
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { _, _ in
        }
    }
    
    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed),
            HKQuantityType.workoutType()
        ]
        
        let typesToRead: Set = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed),
            HKQuantityType.workoutType(),
            HKObjectType.activitySummaryType()
        ]
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, _ in }
    }
    
    // MARK: - Session State Control
    
    @Published var running = false
    
    func togglePause() {
        if running == true {
            session?.pause()
        } else {
            session?.resume()
        }
    }
    
    func endWorkout() {
        session?.end()
        showSummaryView = true
    }
    
    func endWorkoutWithoutSummaryView() {
        session?.end()
        resetWorkout()
    }
    
    // MARK: - Workout Metrics
    @Published var distance: Double = 0
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var calorie: Double = 0
    @Published var pace: Double = 0
    @Published var averagePace: Double = 0
    @Published var stepCount: Double = 0
    @Published var cadence: Double = 0
    @Published var workout: HKWorkout?
    
    // 평균 페이스 계산
    func calculateAveragePace(distance: Double, duration: TimeInterval) {
        if distance > 0 && duration > 0 {
            let averagePaceInSecondsPerKilometer = duration / distance * 1000
            self.averagePace = averagePaceInSecondsPerKilometer
        } else {
            self.averagePace = 0
        }
    }
    
    // 실시간 페이스 계산
    func calculatePaceFromSpeed(speed: Double) {
        if speed > 0 {
            let pace = 1 / speed * 1000
            self.pace = pace
        } else {
            self.pace = 0
        }
    }
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.calorie = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
                let duration = self.builder?.elapsedTime ?? 0
                self.calculateAveragePace(distance: self.distance, duration: duration)
            case HKQuantityType.quantityType(forIdentifier: .runningSpeed):
                let meterPerSecondUnit = HKUnit.meter().unitDivided(by: HKUnit.second())
                let speed = statistics.mostRecentQuantity()?.doubleValue(for: meterPerSecondUnit) ?? 0
                self.calculatePaceFromSpeed(speed: speed)
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let stepCountUnit = HKUnit.count()
                self.stepCount = statistics.averageQuantity()?.doubleValue(for: stepCountUnit) ?? 0
                let duration = self.builder?.elapsedTime ?? 0
                if duration != 0 {
                    self.cadence = self.stepCount/duration
                }
            default:
                return
            }
        }
    }
    
    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
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
    }
}

extension WatchWorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { _, _ in
                self.builder?.finishWorkout { workout, _ in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
}

extension WatchWorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
