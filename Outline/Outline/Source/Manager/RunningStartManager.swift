//
//  RunningStartManager.swift
//  Outline
//
//  Created by hyunjun on 10/25/23.
//

import Combine
import CoreLocation
import HealthKit

class RunningStartManager: ObservableObject {
        
    @Published var counter = 0
    @Published var start = false
    @Published var running = false
    @Published var changeRunningType = false
    
    @Published var isHealthAuthorized = false
    @Published var isLocationAuthorized = false
    @Published var showPermissionSheet = false
    @Published var permissionType: PermissionType?
    
    private var timer: AnyCancellable?
    private var healthStore = HKHealthStore()
    private var locationManager = CLLocationManager()
    var startCourse: GPSArtCourse?
    var runningType: RunningType = .gpsArt
    
    static let shared = RunningStartManager()
    
    private init() { }
    
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
    
    func startFreeRun() {
        startCourse = GPSArtCourse()
        runningType = .free
        getFreeRunName()
    }
    
    func startGPSArtRun() {
        runningType = .gpsArt
    }
    
    private func getFreeRunName() {
        let geocoder = CLGeocoder()
        
        if let userLocation = locationManager.location?.coordinate {
            let start = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            geocoder.reverseGeocodeLocation(start) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let town = placemark.subLocality ?? ""
                    
                    self.startCourse?.courseName = "\(city) \(town)런"
                }
            }
        }
    }
    
    func trackingDistance() {
        if let startCourse {
            if !checkDistance(course: startCourse.coursePaths) {
                changeRunningType = true
            }
        }
    }
    
    func checkDistance(course: [Coordinate]) -> Bool {
        
        guard let userLocation = locationManager.location?.coordinate else { return false }
        
        guard let shortestDistance = calculateShortestDistance(from: userLocation, to: ConvertCoordinateManager.convertToCLLocationCoordinates(course)) else { return false }
        return shortestDistance <= 100
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.counter += 1
            }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    func formattedTime(_ counter: Int) -> String {
        let minutes = counter / 60
        let seconds = counter % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - 위치와 경로를 계산하는 함수

extension RunningStartManager {

    func calculateShortestDistance(from userCoordinate: CLLocationCoordinate2D, to courseCoordinates: [CLLocationCoordinate2D]) -> CLLocationDistance? {
        guard !courseCoordinates.isEmpty else { return nil }

        var shortestDistance: CLLocationDistance?
        
        for courseCoordinate in courseCoordinates {
            let distanceToCourseCoordinate = calculateDistance(from: userCoordinate, to: courseCoordinate)
            if let currentShortestDistance = shortestDistance {
                shortestDistance = min(currentShortestDistance, distanceToCourseCoordinate)
            } else {
                shortestDistance = distanceToCourseCoordinate
            }
        }
        return shortestDistance
    }

    // 두 좌표 사이의 거리를 계산하는 함수
    private func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
}
