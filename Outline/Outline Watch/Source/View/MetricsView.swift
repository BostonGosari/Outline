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
                    VStack {
                        Text("\(workoutManager.activeEnergy.formatted(.number.precision(.fractionLength(0))))")

                            .font(
                                Font.custom("SF Pro Display", size: 32)
                                    .weight(.medium)
                                )
                            .foregroundColor(.white)
                        Text("킬로미터")
                            .font(Font.custom("SF Pro Display", size: 11))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)

                    }
                    Spacer()
                    VStack {
                        Text("\(workoutManager.pace.formatted(.number.precision(.fractionLength(0))))")
                        .font(
                            Font.custom("SF Pro Display", size: 32)
                                .weight(.medium)
                            )
                        .foregroundColor(.white)
                        Text("페이스")
                            .font(Font.custom("SF Pro Display", size: 11))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray500)

                    }
                   
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
