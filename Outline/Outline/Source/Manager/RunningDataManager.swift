//
//  WorkoutDataViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/21/23.
//

import ActivityKit
import CoreMotion
import Combine
import Foundation
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
    
    func startLiveActivity() async {
        await removeActivity()
        await addLiveActivity()
    }
    
    private func addLiveActivity() async {
        if #available(iOS 16.2, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let attribute = RunningAttributes(runningText: "러닝중")
                let state = ActivityContent(state: RunningAttributes.ContentState(totalDistance: "0", totalTime: "00:00", pace: "0'00''", heartrate: "--"), staleDate: nil)
                
                let activity = try? Activity.request(attributes: attribute, content: state)
                guard let activity = activity else {
                    return
                }
                await MainActor.run { activityID = activity.id }
                
                print("activity 생성 \(activity.id )")
                
                for await data in activity.pushTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                    print("Activity token: \(token)")
                    await MainActor.run { activityToken = token }
                    // HERE SEND THE TOKEN TO THE SERVER
                }
            }
        }
    }
    
    func updateLiveActivity(newTotalDistance: String, newTotalTime: String, newPace: String, newHeartrate: String) async {
        guard let activityID = await activityID,
              let runningActivity = Activity<RunningAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        if #available(iOS 16.2, *) {
            Task.detached {
                print("update \(activityID)")
                let newState = RunningAttributes.ContentState(totalDistance: newTotalDistance, totalTime: newTotalTime, pace: newPace, heartrate: newHeartrate)
                print("newState \(newState)")
                await runningActivity.update(using: newState)
            }
        }
    }
    
    func removeActivity() async {
        guard let activityID = await activityID,
              let runningActivity = Activity<RunningAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        if #available(iOS 16.2, *) {
            let initialContentState = RunningAttributes.ContentState( totalDistance: String(self.totalDistance), totalTime: String(self.time), pace: String(self.pace), heartrate: "--")
            
            await runningActivity.end(
                ActivityContent(state: initialContentState, staleDate: Date.distantFuture),
                dismissalPolicy: .immediate
            )
            
            await MainActor.run {
                self.activityID = nil
                self.activityToken = nil
                print(self.activityID == nil ? "아이디를 찾을 수 없습니다. " : " 삭제실패")
            }
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
        
        self.userDataModel.createRunningRecord(record: newRunningRecord) { result in
               switch result {
               case .success:
                   self.userLocations = []
                   
                   // 저장 후에 스코어를 업데이트
                   CourseScoreModel().createOrUpdateScore(courseId: course.id, score: self.score) { scoreResult in
                       switch scoreResult {
                       case .success:
                           print("Score updated successfully")
                       case .failure(let error):
                           print("Error updating score: \(error)")
                       }
                   }
               case .failure(let error):
                   print("Error saving running record: \(error)")
               }
           }
    }
}
