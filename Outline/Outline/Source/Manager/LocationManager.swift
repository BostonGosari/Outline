//
//  LocationManager.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var userLocations: [CLLocationCoordinate2D] = []
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var isAuthorized = false
    @Published var isNext = false
    @Published var nearStartLocation = false
    @Published var isShowCompleteSheet = false
    
    @Published var checkDistance = true
    
    var startLocation: CLLocationCoordinate2D?
    
    private var locationManager = CLLocationManager()
    private var firstLocation = CLLocation()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
    
    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            isAuthorized = false
        case .restricted, .denied:
            isAuthorized = false
            isNext = true
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            isNext = true
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            let distance: CLLocationDistance = 5
            let  location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            self.currentLocation = currentLocation

            if userLocations.isEmpty {
                startLocation = currentLocation
                userLocations.append(currentLocation)
                firstLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            } else if let lastUserLocation = userLocations.last {
                let lastLocation = CLLocation(latitude: lastUserLocation.latitude, longitude: lastUserLocation.longitude)
                
                if location.distance(from: lastLocation) >= distance {
                    userLocations.append(currentLocation)
                }
                
                #if os(iOS)
                if checkDistance == true {
                    let runningManager = RunningManager.shared
                    
                    if let startCourse = runningManager.startCourse {
                        self.checkDistance = runningManager.checkDistance(userLocation: lastUserLocation, course: startCourse.coursePaths)
                        print(checkDistance)
                    }
                }
                
                if checkAccuracy() >= 95.0 {
                    let startToDistance = location.distance(from: firstLocation)
                    if startToDistance <= 5 {
                        isShowCompleteSheet = true
                    } else if  startToDistance <= 30 {
                        nearStartLocation = true
                    } else {
                        nearStartLocation = false
                    }
                }
                #endif
            }
        }
    }
    
#if os(iOS)
    private func checkAccuracy() -> Double {
        let runningManager = RunningManager.shared
        
        if let course = runningManager.startCourse?.coursePaths {
            let guideCourse = ConvertCoordinateManager.convertToCLLocationCoordinates(course)
            let progressManager = CourseProgressManager(guideCourse: guideCourse, userCourse: userLocations)
            progressManager.calculate()
            return progressManager.getProgress()
        }
        return 0
    }
    
    func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
#endif
    
}
