//
//  MatricsView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                             isPaused: workoutManager.session?.state == .paused)) { context in
            VStack(alignment: .center) {
                Spacer()
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Text("\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))")
                            .font(.system(size: 28).weight(.semibold))
                            .foregroundColor(.white)
                        Text("킬로미터")
                            .font(.system(size: 11))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)

                    }
                    Spacer()
                    VStack {
                        Text(workoutManager.pace > 0 ? String(format: "%02d’%02d’’", Int(workoutManager.pace) / 60, Int(workoutManager.pace) % 60) : "-’--’’")

                            .font(.system(size: 28).weight(.semibold))
                            .foregroundColor(.white)
                        Text("페이스")
                            .font(.system(size: 11))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
               
//                Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
//                Text(Measurement(value: workoutManager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
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


#Preview {
    MetricsView().environmentObject(WatchWorkoutManager())
}
