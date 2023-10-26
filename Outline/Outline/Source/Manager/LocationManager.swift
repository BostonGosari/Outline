//
//  LocationManager.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var userLocations: [CLLocationCoordinate2D] = []
    @Published var isAuthorized = false
    @Published var isNext = false
    
    private var locationManager = CLLocationManager()
    
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
            let distance: CLLocationDistance = 10
            let  location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            if userLocations.isEmpty {
                userLocations.append(currentLocation)
            } else if let lastUserLocation = userLocations.last {
                let lastLocation = CLLocation(latitude: lastUserLocation.latitude, longitude: lastUserLocation.longitude)
                
                if  location.distance(from: lastLocation) >= distance {
                    userLocations.append(currentLocation)
                }
            }
        }
    }
    
    #if os(iOS)
    func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    #endif
}
