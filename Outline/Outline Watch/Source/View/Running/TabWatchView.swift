//
//  TabWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct TabWatchView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var connectivityManager = ConnectivityManager.shared
    @StateObject private var workoutManager = WatchWorkoutManager.shared
    @StateObject private var runningManager = WatchRunningManager.shared
    
    @State private var selection: Tab = .metrics
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
            .onChange(of: workoutManager.isRunning) { _, newValue in
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
                Text(workoutManager.isRunning ? runningManager.runningTitle : "일시 정지됨")
                    .foregroundStyle(.customPrimary)
            }
            .onChange(of: connectivityManager.runningState) { _, newValue in
                if newValue == .pause {
                    workoutManager.session?.pause()
                } else if newValue == .resume {
                    workoutManager.session?.resume()
                } else if newValue == .end {
                    if workoutManager.builder?.elapsedTime ?? 0 > 30 {
                        runningManager.userLocations = locationManager.userLocations
                        runningManager.calculateScore()
                        workoutManager.endWorkout()
                    } else {
                        workoutManager.endWorkout()
                        runningManager.startRunning = false
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func sendMirroringData() {
        guard let builder = workoutManager.builder else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if connectivityManager.isMirroring {
                let userLocations = locationManager.userLocations.map { $0.toCoordinate() }
                
                let runningData =
                MirroringRunningData(
                    userLocations: userLocations,
                    time: builder.elapsedTime,
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
        connectivityManager.isMirroring = false
    }
}
