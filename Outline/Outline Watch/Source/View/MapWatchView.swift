//
//  WatchMapView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import MapKit

struct MapWatchView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var runningManager = WatchRunningManager.shared
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    var body: some View {
        Map(position: $position, interactionModes: .zoom) {
            UserAnnotation(anchor: .center) { userlocation in
                ZStack {
                    Circle().foregroundStyle(.white).frame(width: 22)
                    Circle().foregroundStyle(.customPrimary).frame(width: 17)
                }
                .onChange(of: userlocation.location) { _, userlocation in
                    if let user = userlocation {
                        runningManager.userLocations.append(user.coordinate)
                    }
                }
            }
            
            MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(runningManager.startCourse.coursePaths))
                .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            
            MapPolyline(coordinates: runningManager.userLocations)
                .stroke(.customPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
        }
        .mapControlVisibility(.hidden)
        .tint(.customPrimary)
    }
}
