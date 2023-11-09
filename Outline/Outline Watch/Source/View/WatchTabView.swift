//
//  WatchTabView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct WatchTabView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @StateObject var watchRunningManager = WatchRunningManager.shared
    @State private var selection: Tab = .metrics
            
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
            .onChange(of: workoutManager.sessionState) { _, newValue in
                withAnimation {
                    if newValue == .running {
                        selection = .metrics
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
