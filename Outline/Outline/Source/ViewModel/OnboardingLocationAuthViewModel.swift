//
//  OnboardingLocationAuthViewModel.swift
//  Outline
//
//  Created by hyunjun on 10/31/23.
//

import CoreLocation

class OnboardingLocationAuthViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var moveToNextView = false
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            moveToNextView = true
        case .authorizedAlways, .authorizedWhenInUse:
            moveToNextView = true
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
