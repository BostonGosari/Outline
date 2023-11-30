//
//  AppleRunManager.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import Combine
import CoreMotion
import SwiftUI

class AppleRunManager: ObservableObject {
    @Published var counter = 0
    @Published var start = false
    @Published var running = false
    @Published var complete = false
    
    @Published var totalTime = 0.0
    @Published var totalSteps = 0.0
    @Published var totalDistance = 0.0
    @Published var kilocalorie = 0.0
    
    @Published var steps = 0.0
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var avgPace = 0.0
    @Published var cadence = 0.0
    @Published var time = 0.0
    @Published var startDate: Date?
    @Published var endDate: Date?
    
    @Published var progress = 0.0
    
    private var timer: AnyCancellable?
    private let pedometer = CMPedometer()
    
    static let shared = AppleRunManager()
    
    private init() { }
    
    func startRunning() {
        startPedometerUpdates()
        startTimer()
    }
    
    func stopRunning() {
        stopPedometerUpdates()
        stopTimer()
        counter = 0
    }
    
    func pauseRunning() {
        totalSteps += steps
        totalDistance += distance
        totalTime += time
//        time = 0.0
//        steps = 0.0
//        distance = 0.0
        pedometer.stopUpdates()
        stopTimer()
    }
    
    func resumeRunning() {
        startPedometerDataUpdates()
        startTimer()
    }

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.counter += 1
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
    }
    
    private func startPedometerUpdates() {
        startPedometerDataUpdates()
    }
    
    private func startPedometerDataUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available.")
            return
        }
        
        pedometer.startUpdates(from: Date()) { [weak self] (data, _) in
            guard let self = self, let data = data else { return }
            
            DispatchQueue.main.async {
                self.updatePedometerData(data)
            }
        }
    }
    
    private func updatePedometerData(_ data: CMPedometerData) {
        steps = data.numberOfSteps.doubleValue
        distance = data.distance?.doubleValue ?? 0.0
        pace = data.currentPace?.doubleValue ?? 0.0
        cadence = data.currentCadence?.doubleValue ?? 0.0
        avgPace = data.averageActivePace?.doubleValue ?? 0.0
        
        startDate = data.startDate
        endDate = data.endDate
        time = data.endDate.timeIntervalSince(data.startDate)
        
        progress = min(steps / 100, 1.0)
    }
    
    private func stopPedometerUpdates() {
        totalTime += time
        totalSteps += steps
        totalDistance += distance
        pedometer.stopUpdates()
        reset()
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
