//
//  MirroringView.swift
//  Outline
//
//  Created by hyunjun on 11/10/23.
//

import SwiftUI
import HealthKitUI
import HealthKit

struct MirroringView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                
                let fromDate = workoutManager.session?.startDate ?? Date()
                let schedule = MetricsTimelineSchedule(from: fromDate, isPaused: workoutManager.sessionState == .paused)
                
                TimelineView(schedule) { context in
                    VStack {
                        ElapsedTimeView(elapsedTime: workoutTimeInterval(context.date))
                            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        metricsView()
                    }
                }
                
                VStack {
                    Button {
                        startRunningOnWatch()
                    } label: {
                        Text("Start")
                            .foregroundColor(.yellow)
                            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    }
                    
                    Button {
                        if let session = workoutManager.session {
                            if session.state == .running {
                                session.pause()
                            } else {
                                session.resume()
                            }
                        }
                    } label: {
                        Text(workoutManager.session?.state == .running ? "Pause" : "resume")
                            .foregroundColor(.orange)
                            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    }
                    
                    Button {
                        workoutManager.session?.stopActivity(with: .now )
                    } label: {
                        Text("End")
                            .foregroundColor(.red)
                            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    }
                }
            }
            .onAppear {
                workoutManager.retrieveRemoteSession()
            }
        }
    }
    
    private func startRunningOnWatch() {
        Task {
            do {
                try await workoutManager.startWatchWorkout(workoutType: .running)
            } catch {
                print("fail to start running on the paired watch")
            }
        }
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
    
    @ViewBuilder
    private func metricsView() -> some View {
        LabeledContent("Distance", value: workoutManager.distance, format: .number.precision(.fractionLength(0)))
            .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .padding(.horizontal, 40)
    }
}

#Preview {
    MirroringView()
}
