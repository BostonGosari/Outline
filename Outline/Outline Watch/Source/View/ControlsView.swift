//
//  SwiftUIView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import UIKit

struct ControlsView: View {
    
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    @StateObject var watchRunningManager = WatchRunningManager.shared
    @State private var showingConfirmation = false
    @State private var showingEndwithoutSavingSheet = false
    @State private var animate1 = false
    @State private var animate2 = false
    
    var body: some View {
        ScrollView {
            HStack(spacing: 11) {
                ControlButton(systemName: "stop.fill", action: {
                    if workoutManager.workout?.duration ?? 0 > 30 {
                        showingConfirmation = true
                    } else {
                        showingEndwithoutSavingSheet = true
                    }
                }, foregroundColor: .white, backgroundColor: .white)
                
                ControlButton(systemName: workoutManager.running ? "pause" : "play.fill", action: {
                    workoutManager.togglePause()
                    withAnimation {
                        animate1.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            animate2.toggle()
                        }
                    }
                }, foregroundColor: .first, backgroundColor: .first)
            }
            .padding(.top, animate1 ? 20 : WKInterfaceDevice.current().screenBounds.height * 0.25)
            .padding(.bottom, workoutManager.running ? 0 : 24)
            
            if !workoutManager.running {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 24) {
                    workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                    workoutDataItem(value: workoutManager.averagePace.formattedAveragePace(),
                                    label: "평균 페이스")
                    workoutDataItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                    workoutDataItem(value: "\(workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                }
                .padding(.bottom, 20)
                .opacity(animate2 ? 1 : 0)
            }
        }
        .scrollDisabled(workoutManager.running)
        .overlay(alignment: .topLeading) {
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
        .toolbar(.hidden, for: .automatic)
        .overlay {
            if showingConfirmation {
                customExitSheet
            } else if showingEndwithoutSavingSheet {
                customEndWithoutSavingSheet
            }
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
    private var customExitSheet: some View {
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
                    showingConfirmation = false
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
                    showingConfirmation = false
                    workoutManager.endWorkout()
                    
                    let startCourse = watchRunningManager.startCourse
                    
                    let courseData = CourseData(courseName: startCourse.courseName, runningLength: startCourse.courseLength, heading: startCourse.heading, distance: startCourse.distance, coursePaths: watchRunningManager.userLocations, runningCourseId: "")
                    let healthData = HealthData(totalTime: 0.0, averageCadence: workoutManager.cadence, totalRunningDistance: workoutManager.distance, totalEnergy: workoutManager.calorie, averageHeartRate: workoutManager.heartRate, averagePace: workoutManager.pace, startDate: Date(), endDate: Date())
                    
                    watchConnectivityManager.sendRunningRecordToPhone(RunningRecord(id: UUID().uuidString, runningType: watchRunningManager.runningType, courseData: courseData, healthData: healthData))
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
                .padding()
                .padding(.top, 20)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                Button {
                    showingEndwithoutSavingSheet.toggle()
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
                    showingEndwithoutSavingSheet.toggle()
                    workoutManager.endWorkoutWithoutSummaryView()
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
        }
       
    }
}

struct ControlButton: View {
    let systemName: String
    let action: () -> Void
    let foregroundColor: Color
    let backgroundColor: Color
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 24))
                .fontWeight(.black)
                .foregroundColor(foregroundColor)
                .padding()
                .overlay(
                    Circle()
                        .stroke(foregroundColor, lineWidth: 2)
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .foregroundColor(backgroundColor)
                                .opacity(0.5)
                        )
                )
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
}
