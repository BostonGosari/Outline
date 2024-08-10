//
//  MirroringMapWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/22/23.
//

import MapKit
import SwiftUI

struct MirroringMapWatchView: View {
    @StateObject private var connectivityManager = ConnectivityManager.shared
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var bounds: MapCameraBounds = .init(minimumDistance: 100, maximumDistance: 100)
    @State private var interactionModes: MapInteractionModes = []
    @State private var isTapped = false
    @Namespace private var mapScope
    
    var body: some View {
        ZStack {
            Map(position: $position, bounds: bounds, interactionModes: interactionModes, scope: mapScope) {
                UserAnnotation()
                
                if !connectivityManager.runningInfo.course.isEmpty {
                    MapPolyline(coordinates: connectivityManager.runningInfo.course.toCLLocationCoordinates())
                        .stroke(.white.opacity(0.4), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                }
                
                if !connectivityManager.runningData.userLocations.isEmpty {
                    let smoothedLocation = smoothLocations(connectivityManager.runningData.userLocations.toCLLocationCoordinates())
                    MapPolyline(coordinates: smoothedLocation)
                        .stroke(.customPrimary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                }
            }
            .mapControlVisibility(.hidden)
            .mapStyle(.standard(pointsOfInterest: []))
            
            MapUserLocationButton(scope: mapScope)
                .buttonBorderShape(.circle)
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .mapScope(mapScope)
        .ignoresSafeArea(edges: .top)
        .tint(.customPrimary)
        .onAppear {
            interactionModes = [.zoom]
            bounds = .init(minimumDistance: 100, maximumDistance: .infinity)
        }
    }
    
    private var gesture: some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                withAnimation(.easeInOut) {
                    if isTapped {
                        let coordinates = ConvertCoordinateManager.convertToCLLocationCoordinates(connectivityManager.runningInfo.course)
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
    
    private func smoothLocations(_ locations: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        guard locations.count > 1 else { return locations }
       
        var smoothed: [CLLocationCoordinate2D] = []
        
        for i in 0..<locations.count {
            let start = max(0, i - 2)
            let end = min(locations.count - 1, i + 2)
            let subset = Array(locations[start...end])
            
            let avgLatitude = subset.map { $0.latitude }.reduce(0, +) / Double(subset.count)
            let avgLongitude = subset.map { $0.longitude }.reduce(0, +) / Double(subset.count)
            
            smoothed.append(CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude))
        }
        
        return smoothed
    }
}

#Preview {
    MirroringMapWatchView()
}
