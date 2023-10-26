//
//  RunningManager.swift
//  Outline
//
//  Created by hyunjun on 10/25/23.
//

import Foundation
import CoreLocation

class RunningManager: ObservableObject {
    
    private let locationManager = LocationManager()
    
    @Published var start = false
    @Published var running = false
    
    var startCourse: GPSArtCourse?
    var runningType: RunningType = .gpsArt
    
    static let shared = RunningManager()
    
    private init() {
    }
    
    func startFreeRun() {
        startCourse = GPSArtCourse()
        runningType = .free
        locationManager.requestLocation()
        getFreeRunningName()
    }
    
    func startGPSArtRun() {
        runningType = .gpsArt
    }
    
    func getFreeRunningName() {
        let geocoder = CLGeocoder()
        
        if let startLocation = locationManager.startLocation {
            let start = CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude)
            geocoder.reverseGeocodeLocation(start) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let town = placemark.subLocality ?? ""
                    
                    self.startCourse?.courseName = "\(city) \(town)런"
                    print(city)
                    print(town)
                }
            }
        }
    }
    
    func checkDistance(userLocation: CLLocationCoordinate2D, course: [Coordinate]) -> Bool {
        guard let shortestDistance = calculateShortestDistance(from: userLocation, to: convertToCLLocationCoordinates(course)) else {
            print("can't find user location")
            return false
        }
        return shortestDistance <= 2000
    }
}

// MARK: - 위치와 경로를 계산하는 함수

extension RunningManager {

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
