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
    let startCourse: GPSArtCourse
    
    enum Tab {
        case controls, map, metrics
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView(startCourse: startCourse).tag(Tab.controls)
            MapWatchView(course: convertToCLLocationCoordinates(startCourse.coursePaths)).tag(Tab.map)
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
