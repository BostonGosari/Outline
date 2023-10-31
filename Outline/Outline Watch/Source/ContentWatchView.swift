//
//  ContentWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import CoreLocation
import SwiftUI

struct ContentWatchView: View {
    @StateObject private var workoutManager = WatchWorkoutManager()
    
    private var locationManager = CLLocationManager()
    
    var body: some View {
        CourseListWatchView()
            .environmentObject(workoutManager)
            .onAppear {
                workoutManager.requestAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }
    }
}

#Preview {
    ContentWatchView()
}
