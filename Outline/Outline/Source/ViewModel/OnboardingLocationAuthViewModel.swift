//
//  OnboardingLocationAuthViewModel.swift
//  Outline
//
//  Created by hyunjun on 10/31/23.
//

import CoreLocation
import SwiftUI

class OnboardingLocationAuthViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @AppStorage("authState") var authState: AuthState = .onboarding
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
            authState = .login
        case .authorizedAlways, .authorizedWhenInUse:
            moveToNextView = true
            authState = .login
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
