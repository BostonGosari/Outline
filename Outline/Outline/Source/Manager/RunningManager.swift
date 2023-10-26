//
//  RunningManager.swift
//  Outline
//
//  Created by hyunjun on 10/25/23.
//

import Foundation
import CoreLocation

class RunningManager: ObservableObject {
    
    private let locationManager = LocationManager()
    
    @Published var start = false
    @Published var running = false
    
    var startCourse: GPSArtCourse?
    var runningType: RunningType = .gpsArt
    
    static let shared = RunningManager()
    
    private init() {
    }
    
    func startFreeRun() {
        startCourse = GPSArtCourse()
        runningType = .free
        locationManager.requestLocation()
        getFreeRunningName()
    }
    
    func startGPSArtRun() {
        runningType = .gpsArt
    }
    
    func getFreeRunningName() {
        let geocoder = CLGeocoder()
        
        if let startLocation = locationManager.startLocation {
            let start = CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude)
            geocoder.reverseGeocodeLocation(start) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let town = placemark.subLocality ?? ""
                    
                    self.startCourse?.courseName = "\(city) \(town)런"
                    print(city)
                    print(town)
                }
            }
        }
    }
}
