//
//  NewRunningMapView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import MapKit
import SwiftUI

struct NewRunningMapView: View {
    @StateObject private var runningStartManager = RunningStartManager.shared
    @StateObject private var runningDataManager = RunningDataManager.shared
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Namespace private var mapScope
    
    var userLocations: [CLLocationCoordinate2D]
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
                UserAnnotation()
                
                if let courseGuide = runningStartManager.startCourse {
                    MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(courseGuide.coursePaths))
                        .stroke(.black.opacity(0.3), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                }
                
                MapPolyline(coordinates: userLocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
            .mapStyle(.standard(pointsOfInterest: [])) 
            .mapControlVisibility(.hidden)
            .onAppear {
                if let startCourse = runningStartManager.startCourse,
                   !startCourse.coursePaths.isEmpty {
                    runningStartManager.trackingDistance()
                }
            }
            
            MapUserLocationButton(scope: mapScope)
                .buttonBorderShape(.circle)
                .tint(.white)
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 96)
                .padding(.leading, 16)
        }
        .mapScope(mapScope)
        .tint(.customPrimary)
    }
}

#Preview {
    NewRunningMapView(userLocations: [])
}
