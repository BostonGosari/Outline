//
//  WorkoutDataViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/21/23.
//

import SwiftUI
import CoreMotion

class RunningViewModel: ObservableObject {
    @Published var totalTime = 0.0
    
    // 전송용 데이터
    @Published var totalSteps = 0.0
    @Published var totalDistance = 0.0
    @Published var kilocalorie = 0.0
    
    // pedometer 측정값
    @Published var steps = 0.0
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var avgPace = 0.0
    @Published var cadence = 0.0
    @Published var time = 0.0
    @Published var start: Date?
    @Published var end: Date?
    
    // MARK: - Private Properties
    
    private let pedometer: CMPedometer
    private let healthKitManager: HealthKitManager
    
    private let userDataModel = UserDataModel()
    
    private var RunningStartDate = Date()
    private var RunningEndDate = Date()
    
    private let runningManger = RunningManager.shared
    
    // MARK: - Initialization
    
    init() {
        self.pedometer = CMPedometer()
        self.healthKitManager = HealthKitManager()
    }
    
    // MARK: - Public Methods
    
    func startRunning() {
        RunningStartDate = Date()
        startPedometerUpdates()
    }
    
    func stopRunning() {
        RunningEndDate = Date()
        stopPedometerUpdates()
    }
    
    func pauseRunning() {
        totalSteps += steps
        totalDistance += distance
        totalTime += time
        time = 0.0
        steps = 0.0
        distance = 0.0
        pedometer.stopUpdates()
        healthKitManager.pauseWorkout()
    }
    
    func resumeRunning() {
        startPedometerDataUpdates()
        healthKitManager.resumeWorkout()
    }
    
    // MARK: - Private Methods
    
    private func startPedometerUpdates() {
        startPedometerDataUpdates()
        healthKitManager.startWorkout()
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
        
        start = data.startDate
        end = data.endDate
        time = data.endDate.timeIntervalSince(data.startDate)
    }
    
    private func stopPedometerUpdates() {
        totalTime += time
        totalSteps += steps
        totalDistance += distance
        pedometer.stopUpdates()
        healthKitManager.endWorkout(steps: totalSteps, distance: totalDistance, energy: kilocalorie)
        saveRunning()
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
    
    private func saveRunning() {
        guard let course = runningManger.startCourse else { return }
        
        let courseData = CourseData(courseName: course.courseName, runningLength: course.courseLength, heading: course.heading, distance: course.distance, coursePaths: [CLLocationCoordinate2D](), runningCourseId: "")
        
        let healthData = HealthData(totalTime: totalTime, averageCadence: totalSteps / totalDistance, totalRunningDistance: totalDistance / 1000, totalEnergy: kilocalorie, averageHeartRate: 0.0, averagePace: totalTime / totalDistance * 1000 / 60, startDate: RunningStartDate, endDate: RunningEndDate)
        
        let newRunningRecord = RunningRecord(id: UUID().uuidString, runningType: runningManger.runningType, courseData: courseData, healthData: healthData)
        
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
