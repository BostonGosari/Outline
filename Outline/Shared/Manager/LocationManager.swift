//
//  LocationManager.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/19/25.
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var userLocations: [CLLocationCoordinate2D] = []

    override init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let currentLocation = locations.last?.coordinate else { return }

        if let location = manager.location {
            let horizontalAccuracy = location.horizontalAccuracy
            let verticalAccuracy = location.verticalAccuracy
            let speed = location.speed

            if speed > 0.5 && horizontalAccuracy < 20 && verticalAccuracy < 20 {
                userLocations.append(currentLocation)
            }
        }
    }

    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
    }

    func checkLocationAuthorization() -> Bool {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return false
        case .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }

    func getLocationName() async -> (courseName: String?, regionDisplayName: String?) {
        guard let userLocation = locationManager.location?.coordinate else {
            return (courseName: nil, regionDisplayName: nil)
        }
        return await withCheckedContinuation { continuation in
            let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(returning: (courseName: nil, regionDisplayName: nil))
                } else if let placemark = placemarks?.first {
                    let area = placemark.administrativeArea ?? ""
                    let city = placemark.locality ?? ""
                    let town = placemark.subLocality ?? ""
                    let courseName = "\(city) \(town)런"
                    let regionDisplayName = "\(area) \(city) \(town)"
                    continuation.resume(returning: (courseName: courseName, regionDisplayName: regionDisplayName))
                }
            }
        }
    }
}


//import CoreLocation
//import SwiftUI
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var userLocations: [CLLocationCoordinate2D] = []
//    @Published var isRunning: Bool = false
//    @Published var distance = 0.0
//    @Published var direction = ""
//    @Published var nextDirection: (distance: Int, direction: String)?
//    @Published var hotSpot: (location: CLLocation, description: String)?
//    @Published var nearHotSpot = false
//    @Published var navigationDatas: [Navigation]?
//
//    private var locationManager = CLLocationManager()
//    private var index = 1
//
//    static let shared = LocationManager()
//
//    func startUpdate() {
//        isRunning = true
//        userLocations = []
//
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.startUpdatingLocation()
//        locationManager.allowsBackgroundLocationUpdates = true
//    }
//
//    func stopUpdate() {
//        isRunning = false
//        locationManager.stopUpdatingLocation()
//        locationManager.allowsBackgroundLocationUpdates = false
//    }
//
//    func resumeUpdate() {
//        isRunning = true
//        locationManager.startUpdatingLocation()
//        locationManager.allowsBackgroundLocationUpdates = true
//    }
//
//    func initNavigation() {
//        if let navigationDatas = navigationDatas {
//            direction = navigationDatas[index].nextDirection
//            nextDirection = (Int(navigationDatas[index+1].distance), navigationDatas[index+1].nextDirection)
//        }
//    }
//
//    private func checkDistance(_ location: CLLocationCoordinate2D) {
//        if let navigationDatas = navigationDatas {
//            let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//            let targetLocation = CLLocation(latitude: navigationDatas[index].latitude, longitude: navigationDatas[index].longitude)
//            distance = targetLocation.distance(from: currentLocation)
//
//            if let hotSpot {
//                if currentLocation.distance(from: hotSpot.location) < 30 {
//                    nearHotSpot = true
//                }
//            }
//
//            if index+1 < navigationDatas.count {
//                if distance <= 10 {
//                    let nextDistance = CLLocation(latitude: navigationDatas[index+1].latitude, longitude: navigationDatas[index+1].longitude).distance(from: currentLocation)
//                    if nextDistance <= navigationDatas[index+1].distance - 5 {
//                        if navigationDatas[index+1].nextDirection == "핫스팟" {
//                            hotSpot = (
//                                location: CLLocation(latitude: navigationDatas[index+1].latitude, longitude: navigationDatas[index+1].longitude),
//                                description: navigationDatas[index+1].alertMessage
//                            )
//                            index += 2
//                        } else {
//                            index += 1
//                        }
//
//                        distance = nextDistance
//                        direction = navigationDatas[index].nextDirection
//
//                        if index+1 < navigationDatas.count {
//                            nextDirection = (Int(navigationDatas[index+1].distance), navigationDatas[index+1].nextDirection)
//                        } else {
//                            nextDirection = nil
//                        }
//                    }
//                }
//            } else if distance <= 30 {
//                direction = "도착지점이 근처에 있어요!"
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if isRunning,
//           let currentLocation = locations.last?.coordinate {
//
//            if navigationDatas != nil {
//                checkDistance(currentLocation)
//            }
//
//            if let location = manager.location {
//                let horizontalAccuracy = location.horizontalAccuracy
//                let verticalAccuracy = location.verticalAccuracy
//                let speed = location.speed
//
//                if speed > 0.5 && horizontalAccuracy < 20 && verticalAccuracy < 20 {
//                    userLocations.append(currentLocation)
//                }
//            }
//        }
//    }
//}
