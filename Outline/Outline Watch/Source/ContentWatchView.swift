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
    @State private var userLocations: [CLLocationCoordinate2D] = []
    
    var body: some View {
        CourseListWatchView(userLocations: $userLocations, navigate: $navigate)
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView(userLocations: userLocations, navigate: $navigate)
            }
            .environmentObject(workoutManager)
            .onAppear {
                workoutManager.requestAuthorization()
            }
    }
}

#Preview {
    ContentWatchView()
}
