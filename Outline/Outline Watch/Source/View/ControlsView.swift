//
//  SwiftUIView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import UIKit

struct ControlsView: View {
    
    @StateObject var workoutManager = WatchWorkoutManager.shared
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
                
                ControlButton(systemName: workoutManager.running ? "pause" : "play.fill", foregroundColor: .first, backgroundColor: .first) {
                    workoutManager.togglePause()
                    withAnimation {
                        buttonAnimation.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dataAnimation.toggle()
                        }
                    }
                }
            }
            .padding(.top, buttonAnimation ? 20 : WKInterfaceDevice.current().screenBounds.height * 0.2)
            .padding(.bottom, workoutManager.running ? 0 : 30)
            
            if !workoutManager.running {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 12) {
                    workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                    workoutDataItem(value: workoutManager.averagePace.formattedAveragePace(),
                                    label: "평균 페이스")
                    workoutDataItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                    workoutDataItem(value: "\(workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                }
                .padding(.bottom, 20)
                .opacity(dataAnimation ? 1 : 0)
            }
        }
        .scrollDisabled(workoutManager.running)
        .navigationTitle {
            Text(workoutManager.running ? watchRunningManager.runningTitle : "일시 정지됨")
                .foregroundStyle(.first)
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if showConfirmationSheet {
                confirmationSheet
            }
        }
        .sheet(isPresented: $showEndWithoutSavingSheet) {
            customEndWithoutSavingSheet
                .ignoresSafeArea()
        }
    }
    
    private var header: some View {
        Text(workoutManager.running ? "시티런" : "일시 정지됨")
            .fontWeight(.regular)
            .foregroundStyle(.first)
            .padding()
            .padding(.top, 5)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
            }
            .ignoresSafeArea()
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
    
    private var confirmationSheet: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.thinMaterial)
            VStack {
                Spacer()
                Text("종료하시겠어요?")
                    .font(.headline)
                    .padding(.top, 20)
                Spacer()
                
                Button {
                    showConfirmationSheet = false
                } label: {
                    Text("계속 진행하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.gray800.opacity(0.5))
                        )
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                Button {
                    showConfirmationSheet = false
                    sendDataToPhone()
                    workoutManager.endWorkout()
                } label: {
                    Text("종료하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.first)
                        )
                        .foregroundColor(.black)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    private var customEndWithoutSavingSheet: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.thinMaterial)
            VStack {
                VStack(alignment: .leading) {
                    Text("30초 이하는 기록되지 않아요.")
                    Text("러닝을 종료할까요?")
                }
                .font(.system(size: 14))
                .padding()
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                Button {
                    showEndWithoutSavingSheet = false
                } label: {
                    Text("계속 진행하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.gray800.opacity(0.5))
                        )
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                Button {
                    showEndWithoutSavingSheet = false
                    workoutManager.endWorkoutWithoutSummaryView()
                    watchRunningManager.startRunning = false
                    watchConnectivityManager.sendRunningSessionStateToPhone(false)
                } label: {
                    Text("종료하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.first)
                        )
                        .foregroundColor(.black)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 20)
            .overlay(alignment: .topLeading) {
                Image(systemName: "map.circle")
                    .font(.system(size: 42))
                    .foregroundColor(Color.first)
                    .padding(16)
                    .frame(width: 50, height: 50)
            }
            .toolbar(.hidden, for: .automatic)
            .padding()
        }
    }
    
    private func sendDataToPhone() {
        let startCourse = watchRunningManager.startCourse
        guard let builder = workoutManager.builder else { return }
        
        let courseData = CourseData(courseName: startCourse.courseName, runningLength: startCourse.courseLength, heading: startCourse.heading, distance: startCourse.distance, coursePaths: watchRunningManager.userLocations, runningCourseId: "", regionDisplayName: startCourse.regionDisplayName)
        let healthData = HealthData(totalTime: builder.elapsedTime, averageCadence: workoutManager.cadence, totalRunningDistance: workoutManager.distance, totalEnergy: workoutManager.calorie, averageHeartRate: workoutManager.heartRate, averagePace: workoutManager.averagePace, startDate: Date(), endDate: Date())
        
        watchConnectivityManager.sendRunningRecordToPhone(RunningRecord(id: UUID().uuidString, runningType: watchRunningManager.runningType, courseData: courseData, healthData: healthData))
    }
}
