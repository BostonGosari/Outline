//
//  LocationManager.swift
//  Outline
//
//  Created by hyebin on 11/15/23.
//

import CoreLocation
import SwiftUI

struct Route: Codable {
    let nextDirection: String
    let alertMessage: String
    let longitude: Double
    let latitude: Double
    let distance: Double
}
 
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocations: [CLLocationCoordinate2D] = []
    @Published var isRunning: Bool
    @Published var distance = 0.0
    @Published var direction = ""
    @Published var nextDirection: String?
    @Published var hotSopt: (location: CLLocation, description: String)?
    @Published var nearHotSopt = false
    
    private var locationManager = CLLocationManager()
    private var index = 1
    
    static let shared = LocationManager()
    
    // Test
    private var navigationDatas: [Route] = []
    
    override init() {
        isRunning = true
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Test
        getNavigaionData()
    }
    
    // Test
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
        
        direction = navigationDatas[index].nextDirection
        nextDirection = navigationDatas[index+1].nextDirection
    }
    
    private func checkDistance(_ location: CLLocationCoordinate2D) {
        let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let targetLocation = CLLocation(latitude: navigationDatas[index].latitude, longitude: navigationDatas[index].longitude)
        distance = targetLocation.distance(from: currentLocation)
        
        if let hotSopt {
            if currentLocation.distance(from: hotSopt.location) < 30 {
                nearHotSopt = true
            }
        }
        
        if index+1 < navigationDatas.count {
            if distance <= 10 {
                let nextDistance = CLLocation(latitude: navigationDatas[index+1].latitude, longitude: navigationDatas[index+1].longitude).distance(from: currentLocation)
                if nextDistance <= navigationDatas[index+1].distance - 5 {
                    if navigationDatas[index+1].nextDirection == "핫스팟" {
                        hotSopt = (
                            location: CLLocation(latitude: navigationDatas[index+1].latitude, longitude: navigationDatas[index+1].longitude),
                            description: navigationDatas[index+1].nextDirection
                        )
                        index += 2
                    } else {
                        index += 1
                    }
                    
                    distance = nextDistance
                    direction = navigationDatas[index].nextDirection
                    
                    if index+1 < navigationDatas.count {
                        nextDirection = "\(Int(navigationDatas[index+1].distance)) \(navigationDatas[index+1].nextDirection)"
                    } else {
                        nextDirection = nil
                    }
                }
            }
        } else if distance <= 30 {
            direction = "도착지점이 근처에 있어요!"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isRunning,
           let currentLocation = locations.last?.coordinate {
            checkDistance(currentLocation)
            userLocations.append(currentLocation)
        }
    }
}
