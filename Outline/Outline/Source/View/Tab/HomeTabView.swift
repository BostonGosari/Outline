//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct HomeTabView: View {
    @AppStorage("userId") var userId: String?
    @AppStorage("authState") var authState: AuthState = .logout
    
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
                                if authState == .lookAround {
                                    LookAroundView()
                                        .navigationTitle("자유런")
                                } else {
                                    FreeRunningHomeView()
                                }
                            case .GPSArtRunning:
                                GPSArtHomeView(showDetailView: $showDetailView)
                            case .myRecord:
                                if authState == .lookAround {
                                    LookAroundView()
                                        .navigationTitle("기록")
                                } else {
                                    RecordView()
                                }
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
             
            }
            if runningManager.start {
                CountDown(running: $runningManager.running, start: $runningManager.start)
            }
            if runningManager.running {
                RunningView()
            }
            if showCustomSheet {
                WatchRunningSheet
            }
                
        }
        .onAppear {
            AuthModel().handleCheckLoginState { res in
                switch res {
                case .success(let userId):
                    if let userId = userId {
                        self.userId = userId
                        self.authState = .login
                    } else {
                        self.authState = .logout
                    }
                case .failure(let failure):
                    self.authState = .logout
                    print("fail to find userInfo \(failure)")
                }
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
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        showCustomSheet = false
                    }
                }
            VStack(spacing: 0) {
                Text("Apple Watch로 러닝을\n추적하고 있어요")
                    .font(.title2)
                    .padding(.top, 44)
                    .padding(.bottom, 20)
                    .foregroundStyle(Color.customWhite)
                    .multilineTextAlignment(.center)
                Image("RunningWatch")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 16)
                
                Text("휴대폰에서 러닝을 시작하면 별개의\n새로운 러닝이 시작됩니다.")
                    .multilineTextAlignment(.center)
                    .font(.subBody)
                    .padding(.bottom, 30)
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
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color.customPrimary, lineWidth: 2)
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(Color.gray900)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: showCustomSheet ? 0 : UIScreen.main.bounds.height / 2 + 2)
            .animation(.easeInOut, value: showCustomSheet)
            .ignoresSafeArea()
        }
    }
}
