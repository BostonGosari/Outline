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
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    @State private var selectedTab: Tab = .GPSArtRunning
    @State private var showDetailView = false
    @State private var showCustomSheet = false
    
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
                .overlay {
                    if runningDataManager.endWithoutSaving {
                        RunningPopup(text: "30초 이하의 러닝은 저장되지 않아요")
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .sheet(isPresented: $showCustomSheet) {
                    WatchRunningSheet
                }
            }
            if runningManager.start {
                CountDown(running: $runningManager.running, start: $runningManager.start)
            }
            if runningManager.running {
                RunningView()
            }
        }
        .onReceive(watchConnectivityManager.$isWatchRunning) { isRunning in
              if isRunning {
                  showCustomSheet = true
              }
          }
    }
    
}

extension HomeTabView {
    private var WatchRunningSheet: some View {
        VStack(spacing: 0) {
            Text("Apple Watch 러닝")
                .font(.title2)
                .padding(.top, 72)
                .padding(.bottom, 35)
                .foregroundStyle(Color.customWhite)
            Text("지금은 Apple Watch로 러닝을 추적하고 있어요.\n러닝 중에 휴대폰으로 러닝 데이터를 확인하려면\n휴대폰에서 러닝을 시작해야 합니다.\n\n※휴대폰에서 러닝을 시작하면 별개의\n새로운 러닝이 시작됩니다.")
                .multilineTextAlignment(.center)
                .font(.subBody)
                .padding(.bottom, 24)
                .foregroundStyle(Color.gray400)
            Button {
                showCustomSheet.toggle()
            } label: {
                Text("완료")
                    .font(.button)
                    .foregroundStyle(Color.customBlack)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 55)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .foregroundStyle(Color.customPrimary)
                    }
            }
            .padding()
            .padding(.top, 87)
        }
        .presentationDetents([.height(448)])
        .presentationCornerRadius(35)
        .interactiveDismissDisabled()
    }
}

#Preview {
    HomeTabView()
}
