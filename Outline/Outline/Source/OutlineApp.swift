//
//  OutlineApp.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

@main
struct OutlineApp: App {
    private let workoutManager = WorkoutManager.shared
    var body: some Scene {
        WindowGroup {
//            ContentView()
            InputUserInfoView()
                .environmentObject(workoutManager)
        }
    }
}
