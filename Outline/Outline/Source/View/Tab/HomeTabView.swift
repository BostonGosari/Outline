//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct HomeTabView: View {
    
    @StateObject private var homeTabViewModel = HomeTabViewModel()
    @StateObject private var runningManager = RunningManager.shared
    @State var selectedTab: Tab = .GPSArtRunning
    
    @Namespace var namespace
    @State var currentIndex = 0
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
                                GPSArtHomeView(homeTabViewModel: homeTabViewModel, isShow: $showDetailView)
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
                .onAppear {
                    homeTabViewModel.locationManager.requestWhenInUseAuthorization()
                    homeTabViewModel.readAllCourses()
                }
                .refreshable {
                    homeTabViewModel.fetchRecommendedCourses()
                }
            }
            
            if runningManager.start {
                CountDown(running: $runningManager.running, start: $runningManager.start)
            }
            
            if runningManager.running {
                RunningView(homeTabViewModel: homeTabViewModel)
            }
        }
        .tint(.customPrimary)
    }
}

#Preview {
    HomeTabView()
}
