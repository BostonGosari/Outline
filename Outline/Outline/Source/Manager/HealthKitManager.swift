//
//  HealthKitManager.swift
//  Outline
//
//  Created by hyunjun on 10/18/23.
//

import SwiftUI
import CoreMotion
import HealthKit

class HealthKitManager: ObservableObject {
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
    
    func pauseWorkout() {
        guard let builder = workoutBuilder else { return }
        builder.addWorkoutEvents([HKWorkoutEvent(type: .pause, dateInterval: DateInterval(start: Date(), duration: 0), metadata: [:])]) { success, error in
            if success {
                print("workout paused")
            } else if let error = error {
                print("Error : \(error.localizedDescription)")
            }
        }
    }
    
    func resumeWorkout() {
        guard let builder = workoutBuilder else { return }
        builder.addWorkoutEvents([HKWorkoutEvent(type: .resume, dateInterval: DateInterval(start: Date(), duration: 0), metadata: [:])]) { success, error in
            if success {
                print("workout resumed")
            } else if let error = error {
                print("Error : \(error.localizedDescription)")
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
