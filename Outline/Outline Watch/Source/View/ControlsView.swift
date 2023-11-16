//
//  SwiftUIView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import UIKit

struct ControlsView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    @StateObject var watchRunningManager = WatchRunningManager.shared
    
    @State private var showConfirmationSheet = false
    @State private var showEndWithoutSavingSheet = false
    @State private var buttonAnimation = false
    @State private var dataAnimation = false
    
    var body: some View {
        ScrollView {
            HStack(spacing: 11) {
                ControlButton(systemName: "stop.fill", foregroundColor: .white, backgroundColor: .white) {
                    if let builder = workoutManager.builder {
                        if builder.elapsedTime > 30 {
                            showConfirmationSheet = true
                        } else {
                            showEndWithoutSavingSheet = true
                        }
                    }
                }
                
                ControlButton(
                    systemName: workoutManager.session?.state == .paused ? "play.fill" : "pause",
                    foregroundColor: .customPrimary, backgroundColor: .customPrimary) {
                        workoutManager.toggleWorkout()
                    }
            }
            .padding(.top, buttonAnimation ? 20 : WKInterfaceDevice.current().screenBounds.height * 0.2)
            .padding(.bottom, workoutManager.session?.state == .running ? 0 : 30)
            .onChange(of: workoutManager.session?.state) { _, newValue in
                if newValue == .paused {
                    withAnimation {
                        buttonAnimation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dataAnimation = true
                        }
                    }
                } else if newValue == .running {
                    withAnimation {
                        buttonAnimation = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dataAnimation = false
                        }
                    }
                }
            }
            
            if workoutManager.session?.state == .paused {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 12) {
                    workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                    workoutDataItem(value: workoutManager.averagePace.formattedAveragePace(),
                                    label: "평균 페이스")
                    workoutDataItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                    workoutDataItem(value: "\(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                }
                .padding(.bottom, 20)
                .opacity(dataAnimation ? 1 : 0)
            }
        }
        .scrollDisabled(workoutManager.session?.state == .running)
        .navigationTitle {
            if watchConnectivityManager.receivedCourse.coursePaths.isEmpty {
                Text(workoutManager.session?.state == .running ? watchRunningManager.runningTitle : "일시 정지됨")
                    .foregroundStyle(.customPrimary)
            } else {
                Text(workoutManager.session?.state == .running ? watchConnectivityManager.receivedCourse.courseName : "일시 정지됨")
                    .foregroundStyle(.customPrimary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showConfirmationSheet) {
            EndRunningSheet(text: "종료하시겠어요?") {
                showConfirmationSheet = false
                workoutManager.session?.stopActivity(with: .now)
                watchConnectivityManager.sendRunningSessionStateToPhone(false)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showEndWithoutSavingSheet) {
            EndRunningSheet(text: "30초 이하는 기록되지 않아요.\n종료하시겠어요?") {
                showEndWithoutSavingSheet = false
                watchRunningManager.startRunning = false
                workoutManager.session?.stopActivity(with: .now)
                watchConnectivityManager.sendRunningSessionStateToPhone(false)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

extension ControlsView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 24).weight(.semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color.gray500)
        }
    }
}
