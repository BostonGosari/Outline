//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct HomeTabView: View {
    
    @StateObject private var vm = HomeTabViewModel()
    @State var selectedTab: Tab = .GPSArtRunning
    
    @Namespace var namespace
    @State var currentIndex = 0
    @State var isShow = false
    
    var body: some View {
        ZStack {
            if !vm.start && !vm.running {
                NavigationStack {
                    ZStack {
                        Color("Gray900").ignoresSafeArea()
                        ZStack(alignment: .bottom) {
                            Group {
                                switch selectedTab {
                                case .freeRunning:
                                    FreeRunningHomeView(vm: vm)
                                case .GPSArtRunning:
                                    GPSArtHomeView(vm: vm, isShow: $isShow, namespace: namespace)
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
                        vm.readAllCourses()
                    }
                    .refreshable {
                        vm.fetchRecommendedCourses()
                    }
                }
            }

            if vm.start {
                CountDown(running: $vm.running, start: $vm.start)
            }
            
            if vm.running {
                RunningView(vm: vm)
            }
        }
        .tint(.primaryColor)
    }
}

#Preview {
    HomeTabView()
}
