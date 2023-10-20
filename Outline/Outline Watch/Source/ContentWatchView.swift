//
//  ContentWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

struct ContentWatchView: View {
    
    @State private var navigate = false
    @StateObject private var workoutManager = WatchWorkoutManager()

    var body: some View {
//        WatchTabView()
        CourseListWatchView(navigate: $navigate)
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView(navigate: $navigate)
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
