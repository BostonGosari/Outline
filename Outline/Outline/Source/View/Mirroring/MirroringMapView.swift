//
//  MirroringMapView.swift
//  Outline
//
//  Created by hyunjun on 11/11/23.
//

import MapKit
import SwiftUI
import HealthKit

struct MirroringMapView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var workoutManager = WorkoutManager.shared
    @StateObject private var runningStartManager = RunningStartManager.shared
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared

    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Namespace var mapScope
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
                UserAnnotation()
                
                MapPolyline(coordinates: locationManager.userLocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                
                if !watchConnectivityManager.receivedCourse.coursePaths.isEmpty {
                    MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(watchConnectivityManager.receivedCourse.coursePaths))
                        .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                }
                if let startCourse = runningStartManager.startCourse {
                    if !startCourse.coursePaths.isEmpty {
                        MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(startCourse.coursePaths))
                            .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    }
                }
            }
            .mapControlVisibility(.hidden)
            
            VStack(alignment: .trailing) {
                MapUserLocationButton(scope: mapScope)
                    .buttonBorderShape(.circle)
                    .tint(.white)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(.bottom, 96)
                    .padding(.leading, 16)
            }
            .padding(.top, 80)
            .padding(.trailing, 13)
        }
        .mapScope(mapScope)
        .tint(.customPrimary)
    }
}

#Preview {
    MirroringMapView()
}
