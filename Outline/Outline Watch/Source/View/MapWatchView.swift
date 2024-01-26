//
//  WatchMapView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import MapKit

struct MapWatchView: View {
    @StateObject private var runningManager = WatchRunningManager.shared
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var bounds: MapCameraBounds = .init(minimumDistance: 100, maximumDistance: 100)
    @State private var interactionModes: MapInteractionModes = []
    @State private var isTapped = false
    
    var userLocations: [CLLocationCoordinate2D]
    
    var body: some View {
        Map(position: $position, bounds: bounds, interactionModes: interactionModes) {
            UserAnnotation()
            
            if !runningManager.startCourse.coursePaths.isEmpty {
                MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(runningManager.startCourse.coursePaths))
                    .stroke(.white.opacity(0.4), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
            
            if !userLocations.isEmpty {
                MapPolyline(coordinates: userLocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
        }
        .mapControlVisibility(.hidden)
        .mapStyle(.standard(pointsOfInterest: []))
        .ignoresSafeArea(edges: .top)
        .tint(.customPrimary)
        .onAppear {
            if runningManager.runningType == .free {
                interactionModes = [.zoom]
                bounds = .init(minimumDistance: 100, maximumDistance: .infinity)
            }
        }
        .overlay {
            if !runningManager.startCourse.navigation.isEmpty {
                NavigationTabView()
                    .onAppear {
                        locationManager.navigationDatas = runningManager.startCourse.navigation
                        locationManager.initNavigation()
                    }
            }
        }
        .gesture(gesture)
    }
    
    private var gesture: some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                withAnimation(.easeInOut) {
                    if isTapped {
                        let coordinates = ConvertCoordinateManager.convertToCLLocationCoordinates(runningManager.startCourse.coursePaths)
                        let center = calculateCenter(coordinates: coordinates)
                        let distance = calculateMaxDistance(coordinates: coordinates, from: center) * 6
                        
                        position = .region(.init(center: center, latitudinalMeters: distance, longitudinalMeters: distance))
                        bounds = .init(minimumDistance: distance, maximumDistance: distance)
                        isTapped = false
                    } else {
                        position = .userLocation(followsHeading: true, fallback: .automatic)
                        bounds = .init(minimumDistance: 100, maximumDistance: 100)
                        isTapped = true
                    }
                }
            }
    }
    
    private func calculateCenter(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        var minX = coordinates[0].longitude
        var maxX = coordinates[0].longitude
        var minY = coordinates[0].latitude
        var maxY = coordinates[0].latitude
        
        for coordinate in coordinates {
            minX = min(minX, coordinate.longitude)
            maxX = max(maxX, coordinate.longitude)
            minY = min(minY, coordinate.latitude)
            maxY = max(maxY, coordinate.latitude)
        }
        
        let centerLongitude = (minX + maxX) / 2
        let centerLatitude = (minY + maxY) / 2
        
        return CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
    }
    
    private func calculateMaxDistance(coordinates: [CLLocationCoordinate2D], from center: CLLocationCoordinate2D) -> CLLocationDistance {
        var maxDistance: CLLocationDistance = 0.0
        
        for coordinate in coordinates {
            let location1 = CLLocation(latitude: center.latitude, longitude: center.longitude)
            let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            let distance = location1.distance(from: location2)
            maxDistance = max(maxDistance, distance)
        }
        
        return maxDistance
    }
}
