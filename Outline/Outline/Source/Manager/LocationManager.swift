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
    private var checkNextIndex = false
    
    static let shared = LocationManager()
    
    private override init() {
        userLocations = []
        isRunning = true
        
        super.init()
        
        getNavigaionData()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
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
        
        currentDirection = Route(
            nextDirection: "직진",
            alertMessage: "",
            longitude: navigationDatas[index].longitude,
            latitude: navigationDatas[index].latitude,
            distance: 0
        )
    }
    
    private func checkDistance(_ location: CLLocationCoordinate2D) {
        let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let targetLocation = CLLocation(latitude: navigationDatas[index].latitude, longitude: navigationDatas[index].longitude)
        distance = targetLocation.distance(from: currentLocation)
        
        if checkNextIndex {
            let nextDistance = CLLocation(latitude: navigationDatas[index+1].latitude, longitude: navigationDatas[index+1].longitude).distance(from: currentLocation)
            
            if nextDistance <= navigationDatas[index+1].distance {
                index += 1
                checkNextIndex = false
                
                distance = 0
                
                currentDirection = Route(
                    nextDirection: "직진",
                    alertMessage: "",
                    longitude: navigationDatas[index].longitude,
                    latitude: navigationDatas[index].latitude,
                    distance: 0
                )
            }
        } else {
            
            if distance <= 10 && index+1 < navigationDatas.count {
                checkNextIndex = true
            } else if distance <= 30 {
                currentDirection = Route(
                    nextDirection: navigationDatas[index].nextDirection,
                    alertMessage: navigationDatas[index].alertMessage,
                    longitude: navigationDatas[index].longitude,
                    latitude: navigationDatas[index].latitude,
                    distance: distance
                )
            } else {
                distance = 0
                currentDirection = Route(
                    nextDirection: "직진",
                    alertMessage: "",
                    longitude: navigationDatas[index].longitude,
                    latitude: navigationDatas[index].latitude,
                    distance: 0
                )
            }
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
        }
    }
}
