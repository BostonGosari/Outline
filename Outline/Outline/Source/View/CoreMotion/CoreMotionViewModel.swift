//
//  CoreMotionViewModel.swift
//  Outline
//
//  Created by hyunjun on 10/18/23.
//

import SwiftUI
import CoreMotion
import HealthKit

class CoreMotionViewModel: ObservableObject {
    
    @Published var isTracking: Bool = false
    @Published var steps = 0.0
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var avgPace = 0.0
    @Published var cadence = 0.0
    
    @Published var start: Date?
    @Published var end: Date?
    
    @Published var kilocalorie = 0.0
    
    private var pedometer: CMPedometer
    private var motionManager: CMMotionManager
    private var healthKitManager: HealthKitManager
    
    init() {
        self.pedometer = CMPedometer()
        self.motionManager = CMMotionManager()
        self.healthKitManager = HealthKitManager()
    }
    
    func toggleTracking() {
        if isTracking {
            stopPedometerUpdates()
        } else {
            startPedometerUpdates()
            isTracking = true
        }
    }
    
    func stopPedometerUpdates() {
        pedometer.stopUpdates()
        isTracking = false
        healthKitManager.endWorkout(steps: self.steps, distance: self.distance, energy: self.kilocalorie)
    }
    
    func startPedometerUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available.")
            return
        }
        
        healthKitManager.requestAuthorization { [weak self] (authorized) in
            guard let self = self else { return }
            
            if authorized {
                self.startPedometerDataUpdates()
                healthKitManager.startWorkout()
            } else {
                print("HealthKit authorization was denied.")
            }
        }
    }
    
    private func startPedometerDataUpdates() {
        self.pedometer.startUpdates(from: Date()) { (data, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self.steps = data.numberOfSteps.doubleValue
                    self.distance = data.distance?.doubleValue ?? 0
                    self.pace = data.currentPace?.doubleValue ?? 0.0
                    self.cadence = data.currentCadence?.doubleValue ?? 0.0
                    self.avgPace = data.averageActivePace?.doubleValue ?? 0.0
                    
                    self.start = data.startDate
                    self.end = data.endDate
                }
            }
        }
    }
}

class HealthKitManager {
    
    private var healthStore: HKHealthStore?
    private var workoutConfiguration: HKWorkoutConfiguration?
    private var workoutBuilder: HKWorkoutBuilder?
    
    private var workoutStartDate: Date?
    private var workoutEndDate: Date?
    
    // HKHealthStore나 HKWorkoutConfiguration 등이 생성될 필요가 없는 경우에는 불필요하게 리소스를 소모하는 것을 방지합니다.
    // HKHealthStore.isHealthDataAvailable()와 같은 조건을 사용하여 특정 조건에 따라 초기화를 수행합니다.
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            workoutConfiguration = HKWorkoutConfiguration()
            workoutConfiguration?.activityType = .running
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = self.healthStore else { return }
        
        let typesToShare: Set = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKQuantityType(.runningSpeed),
            HKQuantityType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToShare) { success, _ in
            if success {
                print("requestAuthorization successful")
                completion(true)
            } else {
                print("requestAuthorization denied")
                completion(false)
            }
        }
    }
    
    func startWorkout() {
        workoutStartDate = Date()
        
        guard let startDate = workoutStartDate,
              let configuration = workoutConfiguration,
              let healthStore = healthStore
        else { return }
        
        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())
        self.workoutBuilder = builder
        
        builder.beginCollection(withStart: startDate) { success, error in
            if success {
                print("beginCollection successful")
            } else if let error = error {
                print("Error starting collection: \(error.localizedDescription)")
            }
        }
    }
    
    func endWorkout(steps: Double, distance: Double, energy: Double) {
        workoutEndDate = Date()
        
        guard let startDate = workoutStartDate,
              let endDate = workoutEndDate,
              let builder = workoutBuilder
        else { return }
        
        guard let activeEnergyBurnedquantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
              let distanceWalkingRunningQuantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
              let stepcountQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)
        else { return }
        
        // Quantity 생성
        let activeEnergyBurnedQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: energy)
        let distanceWalkingRunningQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        let stepcountQuantity = HKQuantity(unit: .count(), doubleValue: steps)
        
        // Samples 생성
        let activeEnergyBurned = HKCumulativeQuantitySample(type: activeEnergyBurnedquantityType, quantity: activeEnergyBurnedQuantity, start: startDate, end: endDate)
        let distanceWalkingRunning = HKCumulativeQuantitySample(type: distanceWalkingRunningQuantityType, quantity: distanceWalkingRunningQuantity, start: startDate, end: endDate)
        let stepCount = HKCumulativeQuantitySample(type: stepcountQuantityType, quantity: stepcountQuantity, start: startDate, end: endDate)
        
        // builder에 samples 추가
        let samples = [activeEnergyBurned, distanceWalkingRunning, stepCount]
        builder.add(samples) { success, error in
            if success {
                print("Sample added successfully")
                
                builder.endCollection(withEnd: endDate) { success, error in
                    if success {
                        print("endCollection successful")
                        
                        builder.finishWorkout { _, error in
                            if let error = error {
                                print("Error finishing workout: \(error.localizedDescription)")
                            } else {
                                print("Workout finished successfully")
                            }
                        }
                    } else if let error = error {
                        print("Error ending collection: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                print("Error adding sample: \(error.localizedDescription)")
            }
        }
    }
}
