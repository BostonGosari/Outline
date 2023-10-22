//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct HomeTabView: View {
    
    @StateObject private var homeTabViewModel = HomeTabViewModel()
    @State var selectedTab: Tab = .GPSArtRunning
    
    @Namespace var namespace
    @State var currentIndex = 0
    @State var isShow = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color("Gray900").ignoresSafeArea()
                    ZStack(alignment: .bottom) {
                        Group {
                            switch selectedTab {
                            case .freeRunning:
                                FreeRunningHomeView(homeTabViewModel: homeTabViewModel)
                            case .GPSArtRunning:
                                GPSArtHomeView(homeTabViewModel: homeTabViewModel, isShow: $isShow, namespace: namespace)
                            case .myRecord:
                                Text("나의기록 뷰")
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        TabBar(selectedTab: $selectedTab)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .opacity(isShow ? 0 : 1)
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
            
            if homeTabViewModel.start {
                CountDown(running: $homeTabViewModel.running, start: $homeTabViewModel.start)
            }
            
            if homeTabViewModel.running {
                RunningView(homeTabViewModel: homeTabViewModel)
            }
        }
        .tint(.primaryColor)
    }
}

#Preview {
    HomeTabView()
}
