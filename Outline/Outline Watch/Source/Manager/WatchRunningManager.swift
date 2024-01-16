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
    @Published var locationNetworkError = false
    @Published var startRunning = false
    @Published var runningTitle = ""
    
    @Published var accuracy: Double = 0
    @Published var progress: Double = 0
    @Published var score: Int = 0
    
    private let locationManager = CLLocationManager()
    var startCourse: GPSArtCourse = GPSArtCourse()
    var runningType: RunningType = .gpsArt
    
    func startFreeRun() {
        userLocations = []
        score = 0
        startCourse = GPSArtCourse()
        runningType = .free
        getFreeRunName()
        runningTitle = "자유아트"
        startRunning = true
    }
    
    func startGPSArtRun() {
        userLocations = []
        score = 0
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
        guard let userLocation = locationManager.location?.coordinate else {
            print("error to get user location")
            locationNetworkError = true
            return false
        }
        
        guard let shortestDistance = calculateShortestDistance(from: userLocation, to: ConvertCoordinateManager.convertToCLLocationCoordinates(course)) else {
            print("error to calculate")
            locationNetworkError = true
            return false
        }
        
        locationNetworkError = false
        return shortestDistance <= 50
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
    
    func caculateAccuracyAndProgress() {
        if runningType == .free {
            score = -1
            print("제 점수는요 .. \(score)점입니다 ")
            return
        }

        let progressManager = CourseProgressManager(guideCourse: coordinatesToCLLocationCoordiantes(coordinates: startCourse.coursePaths), userCourse: userLocations)
        progressManager.calculate()
        
        self.progress = progressManager.getProgress()
        
        // 정확도 계산
        let accuracyManager = CourseAccuracyManager(guideCourse: coordinatesToCLLocationCoordiantes(coordinates: startCourse.coursePaths), userCourse: userLocations)
        accuracyManager.calculate(userProgress: progress)
        self.accuracy = accuracyManager.getAccuracy()
        
        self.score = Int(progress * accuracy)
        print("progress \(progress) , accuracy \(accuracy)")
        print("제 점수는요 .. \(score)점입니다 ")
    }
    
    private func coordinatesToCLLocationCoordiantes(coordinates: [Coordinate]) -> [CLLocationCoordinate2D] {
        var clLocations: [CLLocationCoordinate2D] = []
        for coordinate in coordinates {
            clLocations.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        return clLocations
    }
}
