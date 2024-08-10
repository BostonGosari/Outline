//
//  MirroringTabWatchView.swift
//  Outline
//
//  Created by hyunjun on 11/22/23.
//

import SwiftUI

struct MirroringTabWatchView: View {
    @StateObject private var connectivityManager = ConnectivityManager.shared
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, map, metrics
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                MirroringControlsView()
                    .tag(Tab.controls)
                MirroringMapWatchView()
                    .tag(Tab.map)
                MirroringMetricsView()
                    .tag(Tab.metrics)
            }
            .navigationTitle {
                Text(connectivityManager.runningState == .pause ? "일시 정지됨" : connectivityManager.runningInfo.courseName)
                    .foregroundStyle(.customPrimary)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MirroringTabWatchView()
}
