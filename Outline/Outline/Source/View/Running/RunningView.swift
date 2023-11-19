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
                .sheet(isPresented: $runningStartManager.changeRunningType) {
                    GuideToFreeRunningSheet {
                        runningStartManager.startFreeRun()
                    }
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
