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
            }
            
            if workoutManager.showSummaryView {
                SummaryView()
            }
        }
        .tint(.customPrimary)
    }
}

#Preview {
    ContentWatchView()
}
