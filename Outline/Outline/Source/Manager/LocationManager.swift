//
//  LocationManager.swift
//  Outline
//
//  Created by hyebin on 11/15/23.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocations: [CLLocationCoordinate2D]
    @Published var isRunning: Bool
    @Published var currentDirection: Route?
    @Published var distance = 0.0
    
    private var locationManager = CLLocationManager()
    private var navigationDatas = [Route]()
    private var index = 1
    
    static let shared = LocationManager()
    
    private override init() {
        userLocations = []
        isRunning = true
        
        super.init()
        
        getNavigaionData()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        
        setRegion()
    }
    
    private func getNavigaionData() {
        let decoder = JSONDecoder()
        guard let fileLocation = Bundle.main.url(forResource: "test", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let jsonDictionary = try decoder.decode([String: [Route]].self, from: data)
            
            if let routes = jsonDictionary["Route"] {
                navigationDatas = routes
            } else {
                print("JSON parsing error: Key 'Route' not found.")
            }
        } catch {
            print("JSON 파싱 에러: \(error.localizedDescription)")
        }
        
        currentDirection = navigationDatas[index]
        print(currentDirection)
    }
    
    private func setRegion() {
        if let currentDirection = currentDirection {
            let region = CLCircularRegion(
                center: CLLocationCoordinate2D(latitude: currentDirection.latitude, longitude: currentDirection.longitude),
                radius: 2,
                identifier: "\(index)"
            )
            locationManager.startMonitoring(for: region)
        }
    }
    
    private func checkDistance(_ location: CLLocationCoordinate2D) {
        if let direction = currentDirection {
            let targetLocation =  CLLocation(latitude: direction.latitude, longitude: direction.longitude)
            let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            distance = targetLocation.distance(from: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isRunning,
            let currentLocation = locations.last?.coordinate {
            checkDistance(currentLocation)
            userLocations.append(currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if index+1 < navigationDatas.count {
            index += 1
            currentDirection = navigationDatas[index]
            setRegion()
        }
    }
}
