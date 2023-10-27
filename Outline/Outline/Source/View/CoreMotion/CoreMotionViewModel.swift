//
//  CoreMotionViewModel.swift
//  Outline
//
//  Created by hyunjun on 10/18/23.
//

import SwiftUI
import CoreMotion
import HealthKit

class CoreMotionViewModel: ObservableObject {
    
    // pedometer 로 측정하는 데이터 들
    @Published var isTracking: Bool = false
    @Published var steps = 0.0
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var avgPace = 0.0
    @Published var cadence = 0.0
    
    // 시작, 종료 추적
    @Published var start: Date?
    @Published var end: Date?
    @Published var isPaused: Bool = false
    
    // 계산한 키로칼로리 -> 건강앱 데이터 전송용
    @Published var kilocalorie = 0.0
    
    private var pedometer: CMPedometer
    private var motionManager: CMMotionManager
    private var healthKitManager: HealthKitManager
    
    @Published var isHealthKitAuthorizationDenied = false
    
    init() {
        self.pedometer = CMPedometer()
        self.motionManager = CMMotionManager()
        self.healthKitManager = HealthKitManager()
    }
    
    func toggleTracking() {
        if isTracking {
            stopPedometerUpdates()
        } else {
            startPedometerUpdates()
            isTracking = true
        }
    }
    
    func stopPedometerUpdates() {
        pedometer.stopUpdates()
        isTracking = false
        healthKitManager.endWorkout(steps: self.steps, distance: self.distance, energy: self.kilocalorie)
    }
    
    func startPedometerUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available.")
            return
        }
        
        healthKitManager.requestAuthorization { [weak self] (authorized) in
            guard let self = self else { return }
            
            if authorized {
                self.startPedometerDataUpdates()
                healthKitManager.startWorkout()
            } else {
                self.isHealthKitAuthorizationDenied = true
            }
        }
    }
    
    private func startPedometerDataUpdates() {
        self.pedometer.startUpdates(from: Date()) { (data, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self.steps = data.numberOfSteps.doubleValue
                    self.distance = data.distance?.doubleValue ?? 0
                    self.pace = data.currentPace?.doubleValue ?? 0.0
                    self.cadence = data.currentCadence?.doubleValue ?? 0.0
                    self.avgPace = data.averageActivePace?.doubleValue ?? 0.0
                    
                    self.start = data.startDate
                    self.end = data.endDate
                }
            }
        }
    }
}
