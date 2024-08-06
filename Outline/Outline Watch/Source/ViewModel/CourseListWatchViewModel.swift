//
//  CourseListWatchViewModel.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/3/23.
//

import CoreMotion
import HealthKit

class CourseListWatchViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var isHealthAuthorized = false
    @Published var isLocationAuthorized = false
    
    private var healthStore = HKHealthStore()
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkAuthorization() {
        checkHealthAuthorization()
        checkLocationAuthorization()
    }
    
    func checkHealthAuthorization() {
        let quantityTypes: Set = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed),
            HKQuantityType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: quantityTypes, read: quantityTypes) { success, _ in
            DispatchQueue.main.async {
                if success {
                    self.isHealthAuthorized = true
                } else {
                    self.isHealthAuthorized = false
                }
            }
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            isLocationAuthorized = false
        case .restricted, .denied:
            isLocationAuthorized = false
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
