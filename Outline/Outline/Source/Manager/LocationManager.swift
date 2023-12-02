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
    @Published var isRunning: Bool
    @Published var distance = 0.0
    @Published var direction = ""
    @Published var nextDirection: (distance: Int, direction: String)?
    @Published var hotSpot: (location: CLLocation, description: String)?
    @Published var nearHotSpot = false
    @Published var navigationDatas: [Navigation]?
    
    private var locationManager = CLLocationManager()
    private var index = 1
    
    static let shared = LocationManager()
    
    override init() {
        isRunning = true
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let navigationDatas = navigationDatas {
            direction = navigationDatas[index].nextDirection
            nextDirection = (Int(navigationDatas[index+1].distance), navigationDatas[index+1].nextDirection)
        }
    }
    
    private func checkDistance(_ location: CLLocationCoordinate2D) {
        if let navigationDatas = navigationDatas {
            let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let targetLocation = CLLocation(latitude: navigationDatas[index].latitude, longitude: navigationDatas[index].longitude)
            distance = targetLocation.distance(from: currentLocation)
            
            if let hotSpot {
                if currentLocation.distance(from: hotSpot.location) < 30 {
                    nearHotSpot = true
                }
            }
            
            if index+1 < navigationDatas.count {
                if distance <= 10 {
                    let nextDistance = CLLocation(latitude: navigationDatas[index+1].latitude, longitude: navigationDatas[index+1].longitude).distance(from: currentLocation)
                    if nextDistance <= navigationDatas[index+1].distance - 5 {
                        if navigationDatas[index+1].nextDirection == "핫스팟" {
                            hotSpot = (
                                location: CLLocation(latitude: navigationDatas[index+1].latitude, longitude: navigationDatas[index+1].longitude),
                                description: navigationDatas[index+1].alertMessage
                            )
                            index += 2
                        } else {
                            index += 1
                        }
                        
                        distance = nextDistance
                        direction = navigationDatas[index].nextDirection
                        
                        if index+1 < navigationDatas.count {
                            nextDirection = (Int(navigationDatas[index+1].distance), navigationDatas[index+1].nextDirection)
                        } else {
                            nextDirection = nil
                        }
                    }
                }
            } else if distance <= 30 {
                direction = "도착지점이 근처에 있어요!"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isRunning,
           let currentLocation = locations.last?.coordinate {
            
            if navigationDatas != nil {
                checkDistance(currentLocation)
            }
            userLocations.append(currentLocation)
        }
    }
}
