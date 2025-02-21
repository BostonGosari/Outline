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
