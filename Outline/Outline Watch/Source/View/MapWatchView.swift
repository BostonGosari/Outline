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
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    var userLocations: [CLLocationCoordinate2D]
    
    var body: some View {
        Map(position: $position, interactionModes: .zoom) {
            UserAnnotation()
            
            MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(runningManager.startCourse.coursePaths))
                .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            
            MapPolyline(coordinates: userLocations)
                .stroke(.customPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
        }
        .mapControlVisibility(.hidden)
        .tint(.customPrimary)
    }
}
