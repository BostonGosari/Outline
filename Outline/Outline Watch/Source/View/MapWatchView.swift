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
                    Circle().foregroundStyle(.first).frame(width: 17)
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
                .stroke(.first, lineWidth: 8)
        }
        .mapControlVisibility(.hidden)
        .tint(.first)
        .navigationTitle {
            Text(watchRunningManager.runningTitle)
                .foregroundStyle(.first)
        }
        .navigationBarTitleDisplayMode(.inline)
//        .overlay(alignment: .topLeading) {
//            header
//        }
    }
    
    private var header: some View {
        Text("시티런")
            .bold()
            .foregroundStyle(.first)
            .padding()
            .padding(.top, 5)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
            }
            .ignoresSafeArea()
    }
}
