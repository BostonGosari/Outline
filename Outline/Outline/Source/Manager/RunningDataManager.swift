//
//  WorkoutDataViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/21/23.
//

import ActivityKit
import CoreMotion
import Combine
import SwiftUI
import WidgetKit

class RunningDataManager: ObservableObject {
    // 전송용 데이터
    @Published var totalTime = 0.0
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
    
    @Published var userLocations = [CLLocationCoordinate2D]()
    @Published var endWithoutSaving = false
    
    @Published var accuracy: Double = 0
    @Published var progress: Double = 0
    @Published var score: Int = 0
    @Published var num: Int = 0
    
    @MainActor @Published private(set) var activityID: String?
    @MainActor @Published private(set) var activityToken: String?
    
//    @State private var activity : Activity<RunningAttributes>? = nil
    private var cancellable: Set<AnyCancellable> = Set()
    private let pedometer = CMPedometer()
    private let healthKitManager = HealthKitManager()
    
    private let userDataModel = UserDataModel()
    
    private var RunningStartDate = Date()
    private var RunningEndDate = Date()
    
    private let runningManger = RunningStartManager.shared
    
    static let shared = RunningDataManager()
    
    private init() { }
    
    func startRunning() {
        RunningStartDate = Date()
        startPedometerUpdates()
    }
    
    func stopRunningWithoutRecord() {
        RunningEndDate = Date()
        endWithoutSaving = true
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
            self.endWithoutSaving = false
        }
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
        caculateAccuracyAndProgress()
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
    
    func addLiveActivity() async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attribute = RunningAttributes()
        let state = ActivityContent(state: RunningAttributes.ContentState( totalDistance: String(self.totalDistance), totalTime: String(self.time), pace: String(self.pace), heartrate: "--"), staleDate: nil)
        
        do {
            let activity = try? Activity<RunningAttributes>.request(attributes: attribute, content: state)
            guard let activity = activity else {
                       return
                   }
                   await MainActor.run { activityID = activity.id }
            print("activity 생성 \(activity.id )")

            await timer()
        } catch {
            print(error)
        }
    }
    
    func timer() async {
        guard let activityID = await activityID,
        let runningActivity = Activity<RunningAttributes>.activities.first(where: { $0.id == activityID }) else {
                    return
                }
        
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                
                Task {
                    print("update \(activityID)")
                    let newState = RunningAttributes.ContentState(totalDistance: "\(self.totalDistance)", totalTime: "\(self.time)", pace: "\(self.pace)", heartrate: "--")
                    print("newState \(newState)")
                    await runningActivity.update(using: newState)
                }
            }
            .store(in: &cancellable)
    }
    
    func removeActivity() async {
        guard let activityID = await activityID,
                     let runningActivity = Activity<RunningAttributes>.activities.first(where: { $0.id == activityID }) else {
                   return
               }
               let initialContentState = RunningAttributes.ContentState( totalDistance: String(self.totalDistance), totalTime: String(self.time), pace: String(self.pace), heartrate: "--")

               await runningActivity.end(
                   ActivityContent(state: initialContentState, staleDate: Date.distantFuture),
                   dismissalPolicy: .immediate
               )
               
               await MainActor.run {
                   self.activityID = nil
                   self.activityToken = nil
               }
    }
    
    func caculateAccuracyAndProgress() {
        guard let course = runningManger.startCourse else { return }
        // 진행률 계산
        if runningManger.runningType == .free {
            score = -1
            return
        }
        
        let progressManager = CourseProgressManager(guideCourse: coordinatesToCLLocationCoordiantes(coordinates: course.coursePaths), userCourse: userLocations)
        progressManager.calculate()
        self.progress = progressManager.getProgress()
        
        // 정확도 계산
        let accuracyManager = CourseAccuracyManager(guideCourse: coordinatesToCLLocationCoordiantes(coordinates: course.coursePaths), userCourse: userLocations)
        accuracyManager.calculate(userProgress: progress)
        self.accuracy = accuracyManager.getAccuracy()
        
        self.score = Int(progress * accuracy)
        print("progress \(progress) , accuracy \(accuracy)")
        print("제 점수는요 .. \(score)점입니다 ")
    }
    
    private func coordinatesToCLLocationCoordiantes(coordinates: [Coordinate]) -> [CLLocationCoordinate2D] {
        var clLocations: [CLLocationCoordinate2D] = []
        for coordinate in coordinates {
            clLocations.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        return clLocations
    }
    
    private func saveRunning() {
        guard let course = runningManger.startCourse else { return }
        
        let courseData = CourseData(courseName: course.courseName, runningLength: course.courseLength, heading: course.heading, distance: course.distance, coursePaths: userLocations, runningCourseId: "", regionDisplayName: course.regionDisplayName, score: score)
        
        let healthData = HealthData(totalTime: totalTime, averageCadence: totalSteps / totalTime * 60, totalRunningDistance: totalDistance, totalEnergy: kilocalorie, averageHeartRate: 0.0, averagePace: totalTime / totalDistance * 1000, startDate: RunningStartDate, endDate: RunningEndDate)
        
        let newRunningRecord = RunningRecord(id: UUID().uuidString, runningType: runningManger.runningType, courseData: courseData, healthData: healthData)
        
        userDataModel.createRunningRecord(record: newRunningRecord) { result in
            switch result {
            case .success:
                print("saved")
                print(newRunningRecord)
                self.userLocations = []
            case .failure(let error):
                print(error)
            }
        }
    }
}
