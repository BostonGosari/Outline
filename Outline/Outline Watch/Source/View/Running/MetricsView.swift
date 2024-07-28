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
        VStack(alignment: .center) {
            TimelineView(.periodic(from: workoutManager.startDate, by: 1.0)) { context in
                ElapsedTime(time: workoutManager.builder?.elapsedTime(at: context.date) ?? 0)
            }
            HStack {
                Spacer()
                VStack {
                    Text("\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))")
                        .font(.customLargeTitle)
                        .foregroundColor(.white)
                    Text("킬로미터")
                        .font(.customBody)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.gray500)
                    
                }
                Spacer()
                VStack {
                    Text(workoutManager.pace > 0 ? workoutManager.pace.formattedAveragePace() : "-’--’’")
                        .font(.customLargeTitle)
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
