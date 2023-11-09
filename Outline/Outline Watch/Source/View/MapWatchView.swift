//
//  WatchMapView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import MapKit

struct MapWatchView: View {
    @StateObject private var watchRunningManager = WatchRunningManager.shared
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
                        watchRunningManager.userLocations.append(user.coordinate)
                    }
                }
            }
            MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(watchRunningManager.startCourse.coursePaths))
                .stroke(.white.opacity(0.5), lineWidth: 8)
            MapPolyline(coordinates: watchRunningManager.userLocations)
                .stroke(.customPrimary, lineWidth: 8)
        }
        .mapControlVisibility(.hidden)
        .tint(.customPrimary)
        .navigationTitle {
            Text(watchRunningManager.runningTitle)
                .foregroundStyle(.customPrimary)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
