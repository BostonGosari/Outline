//
//  ContentWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/13/23.
//

import CoreLocation
import SwiftUI

struct ContentWatchView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    @StateObject var watchRunningManager = WatchRunningManager.shared
    
    @State private var isSheetActive = false
    
    var body: some View {
        ZStack {
            CourseListWatchView()
                .tint(.customPrimary)
                .onChange(of: workoutManager.sessionState) { _, newValue in
                    if newValue == .ended {
                        if let builder = workoutManager.builder {
                            if builder.elapsedTime > 30 {
                                isSheetActive = true
                            }
                        }
                        watchRunningManager.startRunning = false
                    }
                }
                .sheet(isPresented: $isSheetActive) {
                    sendDataToPhone()
                    workoutManager.resetWorkout()
                } content: {
                    SummaryView()
                        .toolbar(.hidden, for: .navigationBar)
                }
            if watchRunningManager.startRunning {
                CountDownView()
                    .onChange(of: workoutManager.sessionState) { _, newValue in
                        if newValue == .ended {
                            if let builder = workoutManager.builder {
                                if builder.elapsedTime > 30 {
                                    isSheetActive = true
                                }
                            }
                            watchRunningManager.startRunning = false
                        }
                    }
            } else if workoutManager.sessionState == .running || workoutManager.sessionState == .paused {
                ZStack {
                    Color.black.ignoresSafeArea()
                    WatchTabView()
                }
            }
        }
    }
    
    private func sendDataToPhone() {
        let startCourse = watchRunningManager.startCourse
        guard let builder = workoutManager.builder else { return }
        
        let courseData = CourseData(courseName: startCourse.courseName, runningLength: startCourse.courseLength, heading: startCourse.heading, distance: startCourse.distance, coursePaths: watchRunningManager.userLocations, runningCourseId: startCourse.id, regionDisplayName: startCourse.regionDisplayName)
        let healthData = HealthData(totalTime: builder.elapsedTime, averageCadence: workoutManager.cadence, totalRunningDistance: workoutManager.distance, totalEnergy: workoutManager.calorie, averageHeartRate: workoutManager.averageHeartRate, averagePace: workoutManager.averagePace, startDate: workoutManager.session?.startDate ?? Date(), endDate: workoutManager.session?.endDate ?? Date())
        
        watchConnectivityManager.sendRunningRecordToPhone(RunningRecord(id: UUID().uuidString, runningType: watchRunningManager.runningType, courseData: courseData, healthData: healthData))
    }
}

#Preview {
    ContentWatchView()
}
