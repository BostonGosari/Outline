//
//  ContentWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

struct ContentWatchView: View {
    @StateObject private var workoutManager = WatchWorkoutManager()

    var body: some View {
//        WatchTabView()
        CourseListWatchView()
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
            .onAppear {
                workoutManager.requestAuthorization()
            }
//        SummaryView()
    }
}

#Preview {
    ContentWatchView()
}
