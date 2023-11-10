//
//  ContentWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import CoreLocation
import SwiftUI

struct ContentWatchView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    @StateObject var runningManager = WatchRunningManager.shared
    
    @State private var isSheetActive = false
    
    var body: some View {
        ZStack {
            CourseListWatchView()
                .tint(.customPrimary)
                .onChange(of: workoutManager.sessionState) { _, newValue in
                    if newValue == .ended {
                        isSheetActive = true
                    }
                }
                .sheet(isPresented: $isSheetActive) {
                    workoutManager.resetWorkout()
                } content: {
                    SummaryView()
                        .toolbar(.hidden, for: .navigationBar)
                }
            if runningManager.startRunning {
                CountDownView()
                    .onChange(of: workoutManager.sessionState) { _, newValue in
                        if newValue == .ended {
                            isSheetActive = true
                        }
                    }
            } else if workoutManager.sessionState == .running || workoutManager.sessionState == .paused {
                ZStack {
                    Color.black.ignoresSafeArea()
                    WatchTabView()
                }
            }
        }
    }
}

#Preview {
    ContentWatchView()
}
