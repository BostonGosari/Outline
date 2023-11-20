//
//  ContentWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import CoreLocation
import SwiftUI

struct ContentWatchView: View {
    @StateObject var runningManager = WatchRunningManager.shared
    @StateObject var workoutManager = WatchWorkoutManager.shared
    
    var body: some View {
        ZStack {
            CourseListWatchView()
            if runningManager.startRunning {
                CountDownView()
                    .sheet(isPresented: $workoutManager.showSummaryView) {
                        SummaryView()
                            .toolbar(.hidden, for: .navigationBar)
                    }
            }
        }
        .tint(.customPrimary)
    }
}

#Preview {
    ContentWatchView()
}
