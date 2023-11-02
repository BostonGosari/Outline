//
//  WorkoutManager.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import Foundation
import HealthKit

class WatchWorkoutManager: NSObject, ObservableObject {
    let watchConnectivityManager: WatchConnectivityManager

    init(watchConnectivityManager: WatchConnectivityManager) {
        self.watchConnectivityManager = watchConnectivityManager
        super.init()
    }
    
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    var isHealthKitAuthorized: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
      
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }

    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?

    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor

        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { _, _ in
            // The workout has started.
        }
    }

    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
      
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed)
        ]

        // The quantity types to read from the health store.
        // 거리 시간 심박수 칼로리 페이스 케이던스
        let typesToRead: Set = [
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed),
            HKObjectType.activitySummaryType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) {(success, error) in
            if success {
                  // Authorization was successful. Your app can now access health data.
                  print("HealthKit authorization granted.")
            } else {
              // Authorization failed. Handle the error.
              if let error = error {
                  print("HealthKit authorization failed with error: \(error.localizedDescription)")
              }
          }
        }
    }

    // MARK: - Session State Control

    // The app's workout state.
    @Published var running = false
    
    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }

    func pause() {
        session?.pause()
    }

    func resume() {
        session?.resume()
    }

    func endWorkout() {
        session?.end()
        showingSummaryView = true
    }
    
    // MARK: - Workout Metrics
    @Published var distance: Double = 0
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var calorie: Double = 0
    @Published var pace: Double = 0
    @Published var averagePace: Double = 0
    @Published var cadence: Double = 0
    @Published var workout: HKWorkout?
 
    // 평균 페이스 계산
    func calculateAveragePace(distance: Double, duration: TimeInterval) {
        if distance > 0 && duration > 0 {
            let averagePaceInSecondsPerMeter = duration / distance
            
            let averagePaceInMinutesPerKilometer = averagePaceInSecondsPerMeter / 1000
            self.averagePace = averagePaceInMinutesPerKilometer
        } else {
            self.averagePace = 0
        }
    }
    
    // 실시간 페이스 계산
    func calculatePaceFromSpeed(speed: Double) {
        if speed > 0 {
            let pace = 60 / (speed) * 60
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
               case HKQuantityType.quantityType(forIdentifier: .cyclingCadence):
                   let cadenceUnit = HKUnit(from: "count/min")
                   self.cadence = statistics.averageQuantity()?.doubleValue(for: cadenceUnit) ?? 0
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
        calorie = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        cadence = 0
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WatchWorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
            // 러닝 세션의 상태를 iOS 앱으로 전달
            self.watchConnectivityManager.sendRunningSessionStateToPhone(self.running)
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

// MARK: - HKLiveWorkoutBuilderDelegate
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
