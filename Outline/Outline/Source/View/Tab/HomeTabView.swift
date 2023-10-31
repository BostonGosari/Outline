//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject private var runningManager = RunningManager.shared
    @State private var selectedTab: Tab = .GPSArtRunning
    @State private var showDetailView = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color("Gray900").ignoresSafeArea()
                    ZStack(alignment: .bottom) {
                        Group {
                            switch selectedTab {
                            case .freeRunning:
                                FreeRunningHomeView()
                            case .GPSArtRunning:
                                GPSArtHomeView(showDetailView: $showDetailView)
                            case .myRecord:
                                RecordView()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        TabBar(selectedTab: $selectedTab)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .opacity(showDetailView ? 0 : 1)
                            .ignoresSafeArea()
                    }
                }
            }
            
            if runningManager.start {
                CountDown(running: $runningManager.running, start: $runningManager.start)
            }
            
            if runningManager.running {
                RunningView()
            }
        }
    }
}

#Preview {
    HomeTabView()
}
