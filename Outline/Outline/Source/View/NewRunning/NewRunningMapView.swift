//
//  NewRunningMapView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import MapKit
import SwiftUI

struct NewRunningMapView: View {
    @StateObject var runningStartManager = RunningStartManager.shared
    @StateObject var runningDataManager = RunningDataManager.shared
    
    @State private var showBigGuide = false
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var userlocations: [CLLocationCoordinate2D] = []
    @Namespace var mapScope
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
                UserAnnotation()
                
                if let courseGuide = runningStartManager.startCourse {
                    MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(courseGuide.coursePaths))
                        .stroke(.black.opacity(0.3), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                }
                
                MapPolyline(coordinates: userlocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
            .mapControlVisibility(.hidden)
            .onChange(of: CLLocationManager().location) { _, userlocation in
                if let user = userlocation {
                    userlocations.append(user.coordinate)
                }
            }
            
            VStack {
                guideView
                    .frame(width: 113, height: 168)
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
    
    private var guideView: some View {
        ZStack {
            if let course = runningStartManager.startCourse,
               runningStartManager.runningType == .gpsArt {
                CourseGuideView(
                    userLocations: $userlocations,
                    showBigGuide: $showBigGuide,
                    coursePathCoordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(course.coursePaths),
                    courseRotate: course.heading
                )
            }
        }
    }
}

#Preview {
    NewRunningMapView()
}
