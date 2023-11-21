//
//  SwiftUIView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import UIKit

struct ControlsView: View {
    @StateObject var connectivityManager = WatchConnectivityManager.shared
    @StateObject var workoutManager = WatchWorkoutManager.shared
    @StateObject var runningManager = WatchRunningManager.shared
    
    @State private var showEndRunningSheet = false
    @State private var showEndWithoutSavingSheet = false
    @State private var buttonAnimation = false
    @State private var dataAnimation = false
    
    var userLocations: [CLLocationCoordinate2D]
    
    var body: some View {
        ScrollView {
            HStack(spacing: 11) {
                ControlButton(systemName: "stop.fill", foregroundColor: .white, backgroundColor: .white) {
                    if let builder = workoutManager.builder {
                        if builder.elapsedTime > 30 {
                            showEndRunningSheet = true
                        } else {
                            showEndWithoutSavingSheet = true
                        }
                    }
                }
                
                ControlButton(systemName: workoutManager.running ? "pause" : "play.fill", foregroundColor: .customPrimary, backgroundColor: .customPrimary) {
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
        .scrollDisabled(workoutManager.running || workoutManager.showSummaryView)
        .sheet(isPresented: $showEndRunningSheet) {
            EndRunningSheet(text: "종료하시겠어요?") {
                showEndRunningSheet = false
                runningManager.userLocations = userLocations
                sendDataToPhone()
                workoutManager.endWorkout()
            }
        }
        .sheet(isPresented: $showEndWithoutSavingSheet) {
            EndRunningSheet(text: "30초 이하는 기록되지 않아요.\n종료하시겠어요?") {
                showEndWithoutSavingSheet = false
                workoutManager.endWorkoutWithoutSummaryView()
                runningManager.startRunning = false
            }
        }
    }
}

extension ControlsView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .foregroundColor(.white)
                .font(.customLargeTitle)
                .foregroundColor(.white)
            Text(label)
                .font(.customBody)
                .foregroundColor(Color.gray500)
        }
    }
    
    private func sendDataToPhone() {
        let startCourse = runningManager.startCourse
        
        guard let builder = workoutManager.builder else { return }
        
        let courseData = CourseData(courseName: startCourse.courseName, runningLength: startCourse.courseLength, heading: startCourse.heading, distance: startCourse.distance, coursePaths: userLocations, runningCourseId: "", regionDisplayName: startCourse.regionDisplayName)
        let healthData = HealthData(totalTime: builder.elapsedTime, averageCadence: workoutManager.cadence, totalRunningDistance: workoutManager.distance, totalEnergy: workoutManager.calorie, averageHeartRate: workoutManager.heartRate, averagePace: workoutManager.averagePace, startDate: workoutManager.session?.startDate ?? Date(), endDate: workoutManager.session?.endDate ?? Date())
        
        connectivityManager.sendRunningRecordToPhone(RunningRecord(id: UUID().uuidString, runningType: runningManager.runningType, courseData: courseData, healthData: healthData))
    }
}
