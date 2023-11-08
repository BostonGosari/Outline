//
//  MatricsView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    @StateObject var runningManager = WatchRunningManager.shared
    @StateObject var workoutManager = WatchWorkoutManager.shared

    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                    isPaused: workoutManager.session?.state == .paused)) { context in
            VStack(alignment: .center) {
                Spacer()
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0)
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Text("\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))")
                            .font(.system(size: 28).weight(.semibold))
                            .foregroundColor(.white)
                        Text("킬로미터")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)

                    }
                    Spacer()
                    VStack {
                        Text(workoutManager.pace > 0 ? workoutManager.pace.formattedAveragePace() : "-’--’’")

                            .font(.system(size: 28).weight(.semibold))
                            .foregroundColor(.white)
                        Text("페이스")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
            .navigationTitle {
                Text(runningManager.runningTitle)
                    .foregroundStyle(.first)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
