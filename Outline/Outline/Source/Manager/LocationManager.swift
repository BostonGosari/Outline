//
//  LocationManager.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var isAuthorized = false
    @Published var isNext = false
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesEnabled() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
        print(isNext.description)
        print(isAuthorized.description)
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
            isAuthorized = false
        case .restricted, .denied:
            print("denied")
            isAuthorized = false
            isNext = true
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            isAuthorized = true
            isNext = true
        @unknown default:
            break
        }
    }
    
    func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
