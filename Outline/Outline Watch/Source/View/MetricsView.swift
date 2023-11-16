//
//  MatricsView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    @StateObject var workoutManager = WorkoutManager.shared
    @StateObject var runningManager = WatchRunningManager.shared

    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(from: workoutManager.session?.startDate ?? Date(),
                                    isPaused: workoutManager.session?.state == .paused)) { context in
            VStack(alignment: .center) {
                ElapsedTimeView(elapsedTime: elapsedTime(with: context.date))
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundStyle(.customPrimary)
                    .monospacedDigit()
                    .padding(.bottom)
                HStack {
                    Spacer()
                    VStack {
                        Text("\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("킬로미터")
                            .font(.customBody)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)

                    }
                    Spacer()
                    VStack {
                        Text(workoutManager.pace > 0 ? workoutManager.pace.formattedAveragePace() : "-’--’’")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("페이스")
                            .font(.customBody)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
    }
    
    private func elapsedTime(with contextDate: Date) -> TimeInterval {
        return workoutManager.builder?.elapsedTime(at: contextDate) ?? 0
    }
}
