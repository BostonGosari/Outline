//
//  HealthAuthViewModel.swift
//  Outline
//
//  Created by hyunjun on 11/14/23.
//

import HealthKit
import SwiftUI

class HealthAuthViewModel: ObservableObject {
    @Published var moveToInputUserInfoView = false
    private var healthStore = HKHealthStore()
    
    func requestHealthAuthorization() {
        let quantityTypes: Set = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed),
            HKQuantityType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: quantityTypes, read: quantityTypes) {_, _ in
            DispatchQueue.main.async {
                self.moveToInputUserInfoView = true
            }
        }
    }
}
