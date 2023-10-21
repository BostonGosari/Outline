//
//  WorkoutDataViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/21/23.
//

import SwiftUI
import CoreMotion
import HealthKit

class RunningViewModel: ObservableObject {
    
    // 전송용 데이터
    @Published var totalTime = 0.0
    @Published var totalSteps = 0.0
    @Published var totalDistance = 0.0
    
    @Published var steps = 0.0
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var avgPace = 0.0
    @Published var cadence = 0.0
    @Published var time = 0.0
    
    // 시작, 종료 추적
    @Published var start: Date?
    @Published var end: Date?
    @Published var isPaused: Bool = false
    
    // 계산한 키로칼로리 -> 건강앱 데이터 전송용
    @Published var kilocalorie = 0.0
    
    private var pedometer: CMPedometer
    private var motionManager: CMMotionManager
    private var healthKitManager: HealthKitManager
    
    init() {
        self.pedometer = CMPedometer()
        self.motionManager = CMMotionManager()
        self.healthKitManager = HealthKitManager()
    }
    
    func startRunning() {
        startPedometerUpdates()
    }
    
    func stopRunnning() {
        stopPedometerUpdates()
    }
    
    func pauseRunning() {
        totalSteps += steps
        totalDistance += distance
        totalTime += time
        time = 0.0
        print(totalTime)
        steps = 0.0
        distance = 0.0
        pedometer.stopUpdates()
    }
    
    func resumeRunning() {
        startPedometerDataUpdates()
    }
    
    func stopPedometerUpdates() {
        totalTime += time
        print(totalTime)
        totalSteps += steps
        totalDistance += distance
        pedometer.stopUpdates()
        healthKitManager.endWorkout(steps: self.totalSteps, distance: self.totalDistance, energy: self.kilocalorie)
        reset()
    }
    
    func startPedometerUpdates() {
        healthKitManager.requestAuthorization { [weak self] (authorized) in
            guard let self = self else { return }
            
            if authorized {
                self.startPedometerDataUpdates()
                healthKitManager.startWorkout()
            } else {
                print("HealthKit authorization was denied.")
            }
        }
    }
    
    private func startPedometerDataUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available.")
            return
        }
        
        self.pedometer.startUpdates(from: Date()) { (data, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self.steps = data.numberOfSteps.doubleValue
                    self.distance = data.distance?.doubleValue ?? 0.0
                    self.pace = data.currentPace?.doubleValue ?? 0.0
                    self.cadence = data.currentCadence?.doubleValue ?? 0.0
                    self.avgPace = data.averageActivePace?.doubleValue ?? 0.0
                    
                    self.start = data.startDate
                    self.end = data.endDate
                    self.time = data.endDate.timeIntervalSince(data.startDate)
                }
            }
        }
    }
    
    private func reset() {
        totalTime = 0.0
        totalSteps = 0.0
        totalDistance = 0.0
        steps = 0.0
        distance = 0.0
        pace = 0.0
        avgPace = 0.0
        cadence = 0.0
        time = 0.0
    }
}
