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
    @Published var finish = false
    
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
    
    @Published var showAppleRunDetail = false
    
    private var timer: AnyCancellable?
    private let pedometer = CMPedometer()
    private let userDataModel = UserDataModel()
    
    static let shared = AppleRunManager()
    
    let userCoordinates = [CLLocationCoordinate2D(latitude: 36.0145573, longitude: 129.3256066), CLLocationCoordinate2D(latitude: 36.0145583, longitude: 129.3256006), CLLocationCoordinate2D(latitude: 36.0145586, longitude: 129.3255949), CLLocationCoordinate2D(latitude: 36.0145567, longitude: 129.3255882), CLLocationCoordinate2D(latitude: 36.0145534, longitude: 129.3255835), CLLocationCoordinate2D(latitude: 36.0145483, longitude: 129.3255805), CLLocationCoordinate2D(latitude: 36.0145429, longitude: 129.3255784), CLLocationCoordinate2D(latitude: 36.0145377, longitude: 129.3255788), CLLocationCoordinate2D(latitude: 36.0145334, longitude: 129.3255794), CLLocationCoordinate2D(latitude: 36.0145269, longitude: 129.3255828), CLLocationCoordinate2D(latitude: 36.0145223, longitude: 129.3255862), CLLocationCoordinate2D(latitude: 36.0145187, longitude: 129.3255895), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.3255919), CLLocationCoordinate2D(latitude: 36.0145128, longitude: 129.3255982), CLLocationCoordinate2D(latitude: 36.0145131, longitude: 129.3256049), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.32561), CLLocationCoordinate2D(latitude: 36.0145193, longitude: 129.3256133), CLLocationCoordinate2D(latitude: 36.014519, longitude: 129.3256167), CLLocationCoordinate2D(latitude: 36.0145168, longitude: 129.3256204), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.3256257), CLLocationCoordinate2D(latitude: 36.0145147, longitude: 129.3256304), CLLocationCoordinate2D(latitude: 36.0145158, longitude: 129.3256358), CLLocationCoordinate2D(latitude: 36.0145198, longitude: 129.3256402), CLLocationCoordinate2D(latitude: 36.0145238, longitude: 129.3256432), CLLocationCoordinate2D(latitude: 36.0145272, longitude: 129.3256455), CLLocationCoordinate2D(latitude: 36.014531, longitude: 129.3256475), CLLocationCoordinate2D(latitude: 36.0145364, longitude: 129.3256485), CLLocationCoordinate2D(latitude: 36.0145421, longitude: 129.3256495), CLLocationCoordinate2D(latitude: 36.0145472, longitude: 129.3256495), CLLocationCoordinate2D(latitude: 36.0145518, longitude: 129.3256475), CLLocationCoordinate2D(latitude: 36.0145559, longitude: 129.3256445), CLLocationCoordinate2D(latitude: 36.0145572, longitude: 129.3256395), CLLocationCoordinate2D(latitude: 36.0145586, longitude: 129.3256348), CLLocationCoordinate2D(latitude: 36.0145594, longitude: 129.3256294), CLLocationCoordinate2D(latitude: 36.0145591, longitude: 129.3256244), CLLocationCoordinate2D(latitude: 36.0145589, longitude: 129.3256197), CLLocationCoordinate2D(latitude: 36.0145578, longitude: 129.3256147), CLLocationCoordinate2D(latitude: 36.0145602, longitude: 129.3256113), CLLocationCoordinate2D(latitude: 36.0145651, longitude: 129.3256113), CLLocationCoordinate2D(latitude: 36.01457, longitude: 129.3256123), CLLocationCoordinate2D(latitude: 36.0145738, longitude: 129.3256143), CLLocationCoordinate2D(latitude: 36.0145781, longitude: 129.3256167), CLLocationCoordinate2D(latitude: 36.0145808, longitude: 129.3256214), CLLocationCoordinate2D(latitude: 36.0145827, longitude: 129.3256257), CLLocationCoordinate2D(latitude: 36.0145844, longitude: 129.3256311), CLLocationCoordinate2D(latitude: 36.0145819, longitude: 129.3256341), CLLocationCoordinate2D(latitude: 36.0145789, longitude: 129.3256334), CLLocationCoordinate2D(latitude: 36.0145757, longitude: 129.3256304), CLLocationCoordinate2D(latitude: 36.0145735, longitude: 129.3256267), CLLocationCoordinate2D(latitude: 36.0145724, longitude: 129.325622), CLLocationCoordinate2D(latitude: 36.0145711, longitude: 129.325618), CLLocationCoordinate2D(latitude: 36.0145703, longitude: 129.3256147)]
    
    private init() { }
    
    func startRunning() {
        reset()
        startPedometerUpdates()
        startTimer()
    }
    
    func stopRunning() {
        stopPedometerUpdates()
        stopTimer()
        saveRunning()
        reset()
    }
    
    func pauseRunning() {
        totalSteps += steps
        totalDistance += distance
        totalTime += time
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
        
        progress = min(steps / 20, 1.0)
    }
    
    private func stopPedometerUpdates() {
        totalTime += time
        totalSteps += steps
        totalDistance += distance
        pedometer.stopUpdates()
        stopTimer()
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
        progress = 0.0
    }
    
    private func saveRunning() {
        let courseData = CourseData(courseName: "애플런", runningLength: 0.03, heading: 1, distance: 0.03, coursePaths: userCoordinates, runningCourseId: "", regionDisplayName: "애플 디벨로퍼 아카데미", score: 100)
        
        let healthData = HealthData(totalTime: totalTime, averageCadence: totalSteps / totalTime * 60, totalRunningDistance: totalDistance, totalEnergy: kilocalorie, averageHeartRate: 0.0, averagePace: totalTime / totalDistance * 1000, startDate: startDate ?? Date(), endDate: endDate ?? Date())
        
        let newRunningRecord = RunningRecord(id: UUID().uuidString, runningType: .gpsArt, courseData: courseData, healthData: healthData)
        
        userDataModel.createRunningRecord(record: newRunningRecord) { result in
            switch result {
            case .success:
                print("saved")
                print(newRunningRecord)
            case .failure(let error):
                print(error)
            }
        }
    }
}
