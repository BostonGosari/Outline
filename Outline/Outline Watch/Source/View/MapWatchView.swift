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
    @GestureState private var isPressed = false
    
    var userLocations: [CLLocationCoordinate2D]
    
    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            
            MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(runningManager.startCourse.coursePaths))
                .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            
            MapPolyline(coordinates: userLocations)
                .stroke(.customPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
        }
        .mapControlVisibility(.hidden)
        .tint(.customPrimary)
        .overlay {
            TabView {
                smallNavigation
                bigNavigation
            }
            .tabViewStyle(.verticalPage(transitionStyle: .blur))
        }
    }
    
    var smallNavigation: some View {
        HStack {
            Image(systemName: "arrow.triangle.turn.up.right.diamond")
                .font(.customLargeTitle)
            Text("경로를 따라 계속 이동")
                .font(.customSubTitle)
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    var bigNavigation: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
                .ignoresSafeArea()
            Text("hello")
                .font(.customSubTitle)
        }
    }
}
