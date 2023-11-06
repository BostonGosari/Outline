//
//  WatchRunningManager.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/1/23.
//

import CoreLocation

class WatchRunningManager: ObservableObject {
    
    static var shared = WatchRunningManager()
    
    private init() { }
    
    @Published var userLocations: [CLLocationCoordinate2D] = []
    @Published var changeRunningType = false
    @Published var startRunning = false
    @Published var runningTitle = ""
    
    private let locationManager = CLLocationManager()
    var startCourse: GPSArtCourse = GPSArtCourse()
    var runningType: RunningType = .gpsArt
    
    func startFreeRun() {
        userLocations = []
        startCourse = GPSArtCourse()
        runningType = .free
        getFreeRunName()
        runningTitle = "자유러닝"
        startRunning = true
    }
    
    func startGPSArtRun() {
        userLocations = []
        runningType = .gpsArt
        runningTitle = startCourse.courseName
        startRunning = true
    }
    
    func trackingDistance() {
        if !checkDistance(course: startCourse.coursePaths) {
            changeRunningType = true
        }
    }
    
    func checkDistance(course: [Coordinate]) -> Bool {
        
        guard let userLocation = locationManager.location?.coordinate else { return false }
        
        guard let shortestDistance = calculateShortestDistance(from: userLocation, to: ConvertCoordinateManager.convertToCLLocationCoordinates(course)) else { return false }
        return shortestDistance <= 2000
    }
    
    private func calculateShortestDistance(from userCoordinate: CLLocationCoordinate2D, to courseCoordinates: [CLLocationCoordinate2D]) -> CLLocationDistance? {
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
    
    private func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
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
                    
                    self.startCourse.courseName = "\(city) \(town)런"
                }
            }
        }
    }
}
