//
//  OutlineApp.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

@main
struct OutlineWatchApp: App {
    @StateObject private var workoutManager = WatchWorkoutManager()
    var body: some Scene {
        WindowGroup {
            ContentWatchView()
               
        }
    }
}
