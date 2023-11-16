//
//  MirroringMetricsView.swift
//  Outline
//
//  Created by hyunjun on 11/11/23.
//

import SwiftUI

struct MirroringMetricsView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    var showDetail: Bool
    var isPaused: Bool
    
    var body: some View {
        let fromDate = workoutManager.session?.startDate ?? Date()
        let schedule = MetricsTimelineSchedule(from: fromDate, isPaused: workoutManager.sessionState == .paused)
        
        VStack {
            TimelineView(schedule) { context in
                if showDetail {
                    VStack(spacing: 25) {
                        ElapsedTimeView(elapsedTime: workoutTimeInterval(context.date))
                            .font(.customHeadline)
                            .foregroundStyle(.customPrimary)
                        HStack {
                            MetricItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                            MetricItem(value: "\(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                        }
                        HStack {
                            MetricItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                            MetricItem(value: "\(workoutManager.averagePace.formattedAveragePace())", label: "평균 페이스")
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                HStack {
                    VStack(alignment: .center) {
                        ElapsedTimeView(elapsedTime: workoutTimeInterval(context.date))
                            .font(.customTitle)
                        Text("진행시간")
                            .font(.customCaption)
                            .foregroundStyle(.gray400)
                    }
                    .padding(.leading, 40)
                    Spacer()
                }
                .opacity(!isPaused && !showDetail ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func workoutTimeInterval(_ contextDate: Date) -> TimeInterval {
        var timeInterval = workoutManager.elapsedTimeInterval
        if workoutManager.sessionState == .running {
            if let referenceContextDate = workoutManager.contextDate {
                timeInterval += (contextDate.timeIntervalSinceReferenceDate - referenceContextDate.timeIntervalSinceReferenceDate)
            } else {
                workoutManager.contextDate = contextDate
            }
        } else {
            var date = contextDate
            date.addTimeInterval(workoutManager.elapsedTimeInterval)
            timeInterval = date.timeIntervalSinceReferenceDate - contextDate.timeIntervalSinceReferenceDate
            workoutManager.contextDate = nil
        }
        return timeInterval
    }
}

#Preview {
    MirroringView(showMirroringView: .constant(true))
}
