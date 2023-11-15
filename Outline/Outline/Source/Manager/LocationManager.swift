//
//  LocationManager.swift
//  Outline
//
//  Created by hyebin on 11/15/23.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocations: [CLLocationCoordinate2D] = []
    
    private var locationManager = CLLocationManager()
    
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        userLocations = []
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func getNavigaionData() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            userLocations.append(currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit")
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 36.01447, longitude: 129.328), radius: 2, identifier: "id1")
        locationManager.startMonitoring(for: region)
    }
}
