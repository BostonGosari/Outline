//
//  RunningView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.

import SwiftUI

struct RunningView: View {
    @StateObject var runningStartManager = RunningStartManager.shared
    @StateObject var runningDataManager = RunningDataManager.shared
    
    @AppStorage("isFirstRunning") var isFirstRunning = true
    @State var checkRunning = true
    @State var selection = false
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.customBlack
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("Gray900").ignoresSafeArea()
            RunningMapView(selection: $selection)
                .overlay {
                    if selection {
                        WorkoutDataView(selection: $selection)
                            .transition(.move(edge: .trailing))
                    }
                }
                .onAppear {
                    if runningStartManager.running == true {
                        runningDataManager.startRunning()
                        runningStartManager.startTimer()
                    }
                }
            
            ZStack {
                if runningStartManager.changeRunningType && checkRunning {
                    Color.black.opacity(0.5)
                }
                VStack(spacing: 10) {
                    Text("자유코스로 변경할까요?")
                        .font(.customTitle2)
                    Text("앗! 현재 루트와 멀리 떨어져 있어요.")
                        .font(.customSubbody)
                        .foregroundColor(.gray300)
                    Image("AnotherLocation")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                    Button {
                        runningStartManager.startFreeRun()
                        checkRunning = false
                    } label: {
                        Text("자유코스로 변경하기")
                            .font(.customButton)
                            .foregroundStyle(Color.customBlack)
                            .padding()
                            .frame(maxWidth: .infinity)
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
                .offset(y: runningStartManager.changeRunningType && checkRunning ? 0 : UIScreen.main.bounds.height / 2 + 2)
                .animation(.easeInOut, value: runningStartManager.changeRunningType)
                .ignoresSafeArea()
            }
        }
        .overlay {
            if isFirstRunning && runningStartManager.runningType == .gpsArt {
                FirstRunningGuideView(isFirstRunning: $isFirstRunning)
            }
        }
    }
}

#Preview {
    RunningView()
}
