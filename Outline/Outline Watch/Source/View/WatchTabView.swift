//
//  WatchTabView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct WatchTabView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @StateObject var workoutManager = WatchWorkoutManager.shared
    @StateObject var watchRunningManager = WatchRunningManager.shared
    @State private var selection: Tab = .metrics
    
    @State private var mapWatchView = MapWatchView()
    @State private var isMapLoaded = false
        
    enum Tab {
        case controls, map, metrics
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                ControlsView()
                    .tag(Tab.controls)
                MapWatchView()
                    .tag(Tab.map)
                MetricsView()
                    .tag(Tab.metrics)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
            .onChange(of: workoutManager.running) { _, newValue in
                withAnimation {
                    if newValue {
                        selection = .metrics
                    } else {
                        selection = .controls
                    }
                }
            }
            .onChange(of: isLuminanceReduced) { _, _ in
                withAnimation {
                    selection = .metrics
                }
            }
        }
    }
}
