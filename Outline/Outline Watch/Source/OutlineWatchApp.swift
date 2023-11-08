//
//  OutlineApp.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

@main
struct OutlineWatchApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let workoutManager = WorkoutManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentWatchView()
                .environmentObject(workoutManager)
        }
    }
}
