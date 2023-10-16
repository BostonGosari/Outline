//
//  LocationManager.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
//    @Published var userLocation: CLLocationCoordinate2D?
    @Published var isAuthorized = false
    @Published var isNext = false
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
    
    private func checkLocationAuthorizationStatus() {
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            userLocation = location.coordinate
//        }
//    }
    
    func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
