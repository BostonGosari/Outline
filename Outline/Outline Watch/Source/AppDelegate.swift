//
//  AppDelegate.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/8/23.
//

import WatchKit
import HealthKit
import SwiftUI

class AppDelegate: NSObject, WKApplicationDelegate {

    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        Task {
            do {
                WorkoutManager.shared.resetWorkout()
                try await WorkoutManager.shared.startWorkout(workoutConfiguration: workoutConfiguration)
                print("Successfully started workout")
            } catch {
                print("Failed started workout")
            }
        }
    }
}
