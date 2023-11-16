//
//  WatchMapView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import MapKit

struct MapWatchView: View {
    @StateObject private var watchConnectivityManager = WatchConnectivityManager.shared
    @StateObject private var watchRunningManager = WatchRunningManager.shared
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    var body: some View {
        Map(position: $position, interactionModes: .zoom) {
            UserAnnotation()
            
            if !watchConnectivityManager.receivedCourse.coursePaths.isEmpty {
                MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(watchConnectivityManager.receivedCourse.coursePaths))
                    .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            }
                if !watchRunningManager.startCourse.coursePaths.isEmpty {
                    MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(watchRunningManager.startCourse.coursePaths))
                        .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                }
            
            MapPolyline(coordinates: watchRunningManager.userLocations)
                .stroke(.customPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
        }
        .mapControlVisibility(.hidden)
        .onChange(of: CLLocationManager().location) { _, userlocation in
            if let user = userlocation {
                watchRunningManager.userLocations.append(user.coordinate)
            }
        }
        .tint(.customPrimary)
    }
}
