//
//  SummaryView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    @Environment(\.dismiss) var dismiss
    @State private var timeFormatter = ElapsedTimeFormatter()
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    @Binding var navigate: Bool
    @State private var isShowingFinishView = true
    @Namespace var topID
    
    var body: some View {
        if workoutManager.workout == nil {
            ProgressView("Saving Workout")
                .navigationBarHidden(true)
        } else if isShowingFinishView {
            FinishWatchView(completionPercentage: 100)
                .onAppear {
                   scheduleTimerToHideFinishView()
                }
                .navigationBarHidden(true)
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    ConfettiWatchView()
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .padding()
                    Text("그림을 완성했어요!")
                        .padding(.bottom)
                    Text(NSNumber(value: workoutManager.builder?.elapsedTime ?? 0), formatter: timeFormatter)
                        .id(topID)
                        .foregroundColor(Color.first)
                        .font(.system(size: 40, weight: .bold))
                      
                    Text("총시간")
                        .font(.system(size: 11))
                        .foregroundColor(Color.gray500)
                        .padding(.bottom, 32)
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 33) {
                        workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                        workoutDataItem(value: workoutManager.pace > 0
                                        ? String(format: "%02d’%02d’’", Int(workoutManager.pace) / 60, Int(workoutManager.pace) % 60)
                                        : "-’--’’",
                                        label: "평균 페이스")
                        workoutDataItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                        workoutDataItem(value: "\(workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                    }
                    .padding(.bottom, 20)
                    Spacer()
                    Text("Outline 앱에서 전체 활동 기록을 확인하세요.")
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray500)
                        .padding(.bottom, 8)
                    Button {
                        navigate.toggle()
                        dismiss()
                    } label: {
                        Text("완료")
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 2)) {
                                proxy.scrollTo(topID, anchor: .top)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
               
            }
            
        }
    }
    private func scheduleTimerToHideFinishView() {
           Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
               withAnimation {
                   isShowingFinishView = false
               }
           }
    }
}

extension SummaryView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color.gray500)
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
    SummaryView(navigate: .constant(true))
}
