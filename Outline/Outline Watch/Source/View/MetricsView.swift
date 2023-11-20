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
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date(),
                isPaused: workoutManager.session?.state == .paused)
        ) { context in
            VStack(alignment: .center) {
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0)
                HStack {
                    Spacer()
                    VStack {
                        Text("\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))")
                            .font(.system(size: 28).weight(.semibold))
                            .foregroundColor(.white)
                        Text("킬로미터")
                            .font(.customBody)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)
                        
                    }
                    Spacer()
                    VStack {
                        Text(workoutManager.pace > 0 ? workoutManager.pace.formattedAveragePace() : "-’--’’")
                            .font(.system(size: 28).weight(.semibold))
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
        }
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool
    
    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}
