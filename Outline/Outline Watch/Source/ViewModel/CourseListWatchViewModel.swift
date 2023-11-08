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
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, _ in
            if success {
                self.isHealthAuthorized = true
            } else {
                self.isHealthAuthorized = false
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

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .running:
            return "Run"
        default:
            return ""
        }
    }
}
