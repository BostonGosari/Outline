//
//  TabWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct TabWatchView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    @StateObject private var workoutManager = WatchWorkoutManager.shared
    @StateObject private var runningManager = WatchRunningManager.shared
    
    @State private var selection: Tab = .metrics
    @State private var isMapLoaded = false
    @State private var count = 0.0
    @State private var timer: Timer?
    
    enum Tab {
        case controls, map, metrics
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                ControlsView(userLocations: locationManager.userLocations)
                    .tag(Tab.controls)
                MapWatchView(userLocations: locationManager.userLocations)
                    .tag(Tab.map)
                MetricsView()
                    .tag(Tab.metrics)
            }
            .onChange(of: workoutManager.running) { _, newValue in
                withAnimation {
                    if newValue {
                        selection = .metrics
                    } else {
                        selection = .controls
                    }
                }
            }
            .onAppear {
                sendMirroringData()
            }
            .onDisappear {
                stopMirring()
            }
            .navigationTitle {
                Text(workoutManager.running ? runningManager.runningTitle : "일시 정지됨")
                    .foregroundStyle(.customPrimary)
            }
            .onChange(of: connectivityManager.runningState) { _, newValue in
                if newValue == .pause {
                    workoutManager.session?.pause()
                } else if newValue == .resume {
                    workoutManager.session?.resume()
                } else if newValue == .end {
                    if count > 30 {
                        runningManager.userLocations = locationManager.userLocations
                        runningManager.calculateScore()
                        sendDataToPhone()
                        workoutManager.endWorkout()
                    } else {
                        workoutManager.endWorkoutWithoutSummaryView()
                        runningManager.startRunning = false
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func sendMirroringData() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if workoutManager.running {
                count += 1
            }
            
            if connectivityManager.isMirroring {
                let userLocations = ConvertCoordinateManager.convertToCoordinates(locationManager.userLocations)
                
                let runningData =
                MirroringRunningData(
                    userLocations: userLocations,
                    time: count,
                    distance: workoutManager.distance,
                    kcal: workoutManager.calorie,
                    pace: workoutManager.pace,
                    bpm: workoutManager.heartRate
                )
                
                connectivityManager.sendRunningData(runningData)
            }
        }
    }
    
    private func stopMirring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func sendDataToPhone() {
        let startCourse = runningManager.startCourse
        
        guard let builder = workoutManager.builder else { return }
        
        let courseData = CourseData(courseName: startCourse.courseName, runningLength: startCourse.courseLength, heading: startCourse.heading, distance: startCourse.distance, coursePaths: locationManager.userLocations, runningCourseId: "", regionDisplayName: startCourse.regionDisplayName, score: runningManager.score)
        let healthData = HealthData(totalTime: builder.elapsedTime, averageCadence: workoutManager.cadence, totalRunningDistance: workoutManager.distance, totalEnergy: workoutManager.calorie, averageHeartRate: workoutManager.heartRate, averagePace: workoutManager.averagePace, startDate: workoutManager.session?.startDate ?? Date(), endDate: workoutManager.session?.endDate ?? Date())
        
        connectivityManager.sendRunningRecordToPhone(RunningRecord(id: UUID().uuidString, runningType: runningManager.runningType, courseData: courseData, healthData: healthData))
    }
}
