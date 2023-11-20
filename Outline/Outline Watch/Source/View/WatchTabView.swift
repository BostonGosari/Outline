//
//  WatchTabView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct WatchTabView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var workoutManager = WatchWorkoutManager.shared
    @StateObject private var runningManager = WatchRunningManager.shared
    
    @State private var selection: Tab = .metrics
    @State private var isMapLoaded = false
        
    enum Tab {
        case controls, map, metrics
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                ControlsView()
                    .tag(Tab.controls)
                MapWatchView(userLocations: locationManager.userLocations)
                    .tag(Tab.map)
                MetricsView()
                    .tag(Tab.metrics)
            }
            .onChange(of: workoutManager.running) { _, newValue in
                withAnimation {
                    if newValue {
                        selection = .metrics
                    } else {
                        selection = .controls
                    }
                }
            }
            .navigationTitle {
                Text(workoutManager.running ? runningManager.runningTitle : "일시 정지됨")
                    .foregroundStyle(.customPrimary)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
