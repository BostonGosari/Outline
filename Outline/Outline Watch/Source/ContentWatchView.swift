//
//  ContentWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import CoreLocation
import SwiftUI

struct ContentWatchView: View {
    @ObservedObject private var workoutManager: WatchWorkoutManager
    
    private var locationManager = CLLocationManager()
    
    init() {
         self.workoutManager = WatchWorkoutManager(watchConnectivityManager: WatchConnectivityManager())
     }
    
    var body: some View {
        CourseListWatchView()
            .environmentObject(workoutManager)
            .onAppear {
                workoutManager.requestAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }
            .tint(.first)
    }
}

#Preview {
    ContentWatchView()
}
