//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject private var runningManager = RunningStartManager.shared
    @StateObject var runningDataManager = RunningDataManager.shared
    @StateObject var watchConnectivityManager = ConnectivityManager.shared
    @State private var selectedTab: Tab = .GPSArtRunning
    @State private var showDetailView = false
    @State private var showMirroringSheet = false
    
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
                            .offset(y: getSafeArea().bottom == 0 ? 25 : 0)
                    }
                }
                .sheet(isPresented: $runningManager.showPermissionSheet) {
                    PermissionSheet(permissionType: runningManager.permissionType)
                }
                .overlay {
                    if runningDataManager.endWithoutSaving {
                        RunningPopup(text: "30초 이하의 러닝은 저장되지 않아요")
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
            }
            if runningManager.start {
                CountDown(running: $runningManager.running, start: $runningManager.start)
            }
            if runningManager.complete {
                FinishRunningView()
            }
            if runningManager.running {
                RunningView()
                    .onAppear {
                        watchConnectivityManager.sendRunningState(.start)
                    }
            }
            if runningManager.mirroring {
                MirroringView()
                    .transition(.move(edge: .bottom))
            }
        }
        .sheet(isPresented: $showMirroringSheet) {
            Mirroringsheet {
                runningManager.mirroring = true
                watchConnectivityManager.sendIsMirroring(true)
            }
        }
        .onChange(of: watchConnectivityManager.runningState) { _, newValue in
            if newValue == .start {
                showMirroringSheet = true
            } else if newValue == .end {
                showMirroringSheet = false
                runningManager.mirroring = false
            }
        }
    }
}

#Preview {
    HomeTabView()
}
