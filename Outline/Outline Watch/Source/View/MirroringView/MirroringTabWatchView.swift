//
//  MirroringTabWatchView.swift
//  Outline
//
//  Created by hyunjun on 11/22/23.
//

import SwiftUI

struct MirroringTabWatchView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    @State private var selection: Tab = .metrics

    enum Tab {
        case controls, map, metrics
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                Text("Hello, World!")
            }
            .navigationTitle {
                Text(connectivityManager.runningState == .start ? connectivityManager.runningInfo.courseName : "일시 정지됨")
                    .foregroundStyle(.customPrimary)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MirroringTabWatchView()
}
