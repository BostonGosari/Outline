//
//  CountDownView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/3/23.
//

import os
import SwiftUI
import HealthKit

struct CountDownView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    @State private var countdownSeconds = 3
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .ignoresSafeArea()
            if countdownSeconds > 0 {
                Image("Count\(countdownSeconds)")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            countdownSeconds -= 1
                            if countdownSeconds == 0 {
                                timer.invalidate()
                            }
                        }
                    }
                    .onDisappear {
                        startWorkout()
                    }
            } else {
                WatchTabView()
            }
        }
    }
    
    private func startWorkout() {
        Task {
            do {
                let configuration = HKWorkoutConfiguration()
                configuration.activityType = .running
                configuration.locationType = .outdoor
                try await workoutManager.startWorkout(workoutConfiguration: configuration)
                print("start")
            }
        }
    }
}

#Preview {
    CountDownView()
}
