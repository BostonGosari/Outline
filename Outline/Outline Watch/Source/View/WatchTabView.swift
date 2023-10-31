//
//  WatchTabView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct WatchTabView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .metrics
    @Binding var userLocations: [CLLocationCoordinate2D]
    var startCourse: GPSArtCourse
    private let locationManager = CLLocationManager()
    
    enum Tab {
        case controls, map, metrics
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView(startCourse: startCourse).tag(Tab.controls)
            MapWatchView(course: ConvertCoordinateManager.convertToCLLocationCoordinates(startCourse.coursePaths), userLocations: $userLocations).tag(Tab.map)
            MetricsView().tag(Tab.metrics)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: workoutManager.running) { _, _ in
            workoutManager.running ?
            displayMetricsView()
            : displayControlsView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _, _ in
            displayMetricsView()
        }
    }
    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
    private func displayControlsView() {
        withAnimation {
            selection = .controls
        }
    }
}
