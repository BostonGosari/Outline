//
//  RunningViewModel.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/19/25.
//

import ActivityKit
import CoreMotion
import Combine
import Foundation
import SwiftUI
import WidgetKit

struct PedometerInfo {
    var steps = 0.0
    var distance = 0.0
    var pace = 0.0
    var avgPace = 0.0
    var cadence = 0.0
    var time = 0.0
    var start: Date?
    var end: Date?
}

struct TotalRunningInfo {
    var totalTime = 0.0
    var totalStep = 0.0
    var totalDistance = 0.0
    var kilocalorie = 0.0
}

/// GPSArt, FreeRun 모두를 담당하는 Running을 관리하는 ViewModel
@MainActor
final class RunningViewModel: ObservableObject {
    @AppStorage("isFirstRunning") var isFirstRunning = true
    /// 러닝 타임
    @Published var time = 0
    private var timer: AnyCancellable?
    var formattedTimeText: String {
        formattedTime(time)
    }

    /// Authorization
    @Published var permissionType: PermissionType?
    @Published var showPermissionSheet = false

    /// 러닝 정보
    @Published var totalRunningInfo: TotalRunningInfo
    @Published var pedometerInfo: PedometerInfo
    @Published var userLocations: [CLLocationCoordinate2D] = []
    var selectedCourse: GPSArtCourse? {
        environmentStateManager.selectedCourse?.course
    }
    var runningStartTime = Date()
    var runningEndTime = Date()

    // LiveActivity
    @Published private(set) var activityID: String?
    @Published private(set) var activityToken: String?

    // View
    @Published var showCompleteSheet = false
    @Published var isToggleMiniGuide = false
    @Published var showDetailMetrics = false
    @GestureState var onPressStopButton = false
    @Published var isPaused = false
    @Published var showStopPopup = false
    @Published var metricsTranslation: CGFloat = 0.0
    @Published var metricsSheetHeight: CGFloat = 0.0

    // 유저 정보
    private let weight: Double = 60

    // Implementations
    private let distanceManager = DistanceManager()
    private let healthKitManager = HealthKitManager()
    private let locationManager = LocationManager()
    private let userDataModel = UserDataModel()
    private let pedometer = CMPedometer()
    private let connectivityManger = ConnectivityManager.shared
    private let environmentStateManager = EnvironmentStateManager.shared

    var course: GPSArtCourse? {
        environmentStateManager.selectedCourse?.course
    }
    var runningType: RunningType {
        environmentStateManager.runningType
    }

    private var cancellable: Set<AnyCancellable> = Set()

    init() {
        self.totalRunningInfo = TotalRunningInfo()
        self.pedometerInfo = PedometerInfo()
    }

    func setupSink() {
        $time
            .sink { [weak self] newValue in
                guard let self else { return }
                if connectivityManger.isMirroring {
                    let userLocations = locationManager.userLocations.map { $0.toCoordinate() }

                    let runningData = MirroringRunningData(
                        userLocations: userLocations,
                        time: Double(newValue),
                        distance: totalRunningInfo.totalDistance,
                        kcal: totalRunningInfo.kilocalorie,
                        pace: pedometerInfo.pace,
                        bpm: 0
                    )

                    connectivityManger.sendRunningData(runningData)
                }
                userLocations = locationManager.userLocations
                if activityID != nil {
                    // 시간이 바뀔 때마다 호출
                    updateLiveActivity(
                        newTotalDistance: String(format: "%.2f", (totalRunningInfo.totalDistance + pedometerInfo.distance)/1000),
                        newTotalTime: formattedTime(newValue),
                        newPace: String(pedometerInfo.pace.formattedCurrentPace()),
                        newHeartrate: "--"
                    )
                }
            }
            .store(in: &cancellable)
        connectivityManger.$runningState
            .sink { [weak self] newValue in
                guard let self else { return }
                if newValue == .pause {
                    tapPauseRunningButton()
                } else if newValue == .resume {
                    tapResumeRunningButton()
                } else if newValue == .end {
                    onEndedLongpreseGesture()
                    connectivityManger.sendRunningState(.end)
                }
            }
            .store(in: &cancellable)
        $isPaused
            .sink { [weak self] newValue in
                guard !newValue, let self else { return }
                withAnimation {
                    self.showDetailMetrics = false
                }
                startTimer()
                if connectivityManger.isMirroring {
                    connectivityManger.sendRunningState(.resume)
                }
            }
            .store(in: &cancellable)
        $pedometerInfo
            .sink { [weak self] newValue in
                guard let self else { return }
                self.totalRunningInfo.kilocalorie = self.weight * (self.totalRunningInfo.totalDistance + newValue.distance) / 1000 * 1.036
            }
            .store(in: &cancellable)

    }

    func onAppear() {
        locationManager.userLocations = []
        startRunning()
        Task {
            await startLiveActivity()
        }
        runningStartTime = Date()
    }

    func toggleShowDetailButton() {
        withAnimation {
            showDetailMetrics.toggle()
        }
    }

    func tapResumeRunningButton() {
        withAnimation {
            showDetailMetrics = false
            isPaused = false
        }
        resumeRunning()
        if connectivityManger.isMirroring {
            connectivityManger.sendRunningState(.resume)
        }
    }

    func tapPauseRunningButton() {
        withAnimation {
            showDetailMetrics = true
            isPaused = true
        }
        stopRunnning()
        if connectivityManger.isMirroring {
            connectivityManger.sendRunningState(.pause)
        }
    }

    @MainActor
    func onEndedLongpreseGesture() {

            if self.time < 30 {
                self.stopTimer()
                self.environmentStateManager.goToHome()
                if connectivityManger.isMirroring {
                    connectivityManger.sendRunningState(.end)
                }
            } else {
                self.finishRunning()
                if connectivityManger.isMirroring {
                    connectivityManger.sendRunningState(.end)
                }
            }

    }

    func onEndedTapGesture() {
        withAnimation {
            showStopPopup = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showStopPopup = false
        }
    }

    func onDisappear() {
        time = 0
    }

    func checkAuthorization() {
        Task {
            if await healthKitManager.checkAuthorization() == false {
                showPermissionSheet = true
                permissionType = .health
                return
            }
            if locationManager.checkLocationAuthorization() == false {
                showPermissionSheet = true
                permissionType = .location
                return
            }
        }
    }

    func startRunning() {
        Task {
            startTimer()
            startPedometerDataUpdates()
            healthKitManager.startWorkout()
            locationManager.startUpdateLocation()
            await startLiveActivity()
        }
    }

    func stopRunnning() {
        stopTimer()
        healthKitManager.pauseWorkout()
        locationManager.stopUpdateLocation()
    }

    func resumeRunning() {
        startTimer()
        healthKitManager.resumeWorkout()
        locationManager.startUpdateLocation()

    }

    func finishRunning() {
        Task {
            runningEndTime = Date()
            self.stopTimer()
            self.healthKitManager.endWorkout(steps: totalRunningInfo.totalStep, distance: totalRunningInfo.totalDistance, energy: totalRunningInfo.kilocalorie)

            self.environmentStateManager.finishRunning()
            await saveRecord()
            reset()
        }
    }
}

// Pedometer
private extension RunningViewModel {
    func startPedometerDataUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available.")
            return
        }

        pedometer.startUpdates(from: Date()) { [weak self] (data, _) in
            guard let self = self, let data = data else { return }

            DispatchQueue.main.async {
                self.pedometerInfo = PedometerInfo(
                    steps: data.numberOfSteps.doubleValue,
                    distance: data.distance?.doubleValue ?? 0.0,
                    pace:  data.currentPace?.doubleValue ?? 0.0,
                    avgPace: data.averageActivePace?.doubleValue ?? 0.0,
                    cadence: data.currentPace?.doubleValue ?? 0.0,
                    time: data.endDate.timeIntervalSince(data.startDate),
                    start: data.startDate,
                    end: data.endDate
                )
            }
        }
    }

    func stopPedometerUpdates() {
        totalRunningInfo.totalTime += pedometerInfo.time
        totalRunningInfo.totalStep += pedometerInfo.steps
        totalRunningInfo.totalDistance += pedometerInfo.distance
        pedometer.stopUpdates()
    }

    func reset() {
        pedometerInfo = PedometerInfo()
    }
}

// UserDataModel
private extension RunningViewModel {
    private func saveRecord() async {
        await withCheckedContinuation { continuation in
            let course: GPSArtCourse
            if let courseWithDistanceAndScore = environmentStateManager.selectedCourse {
                course = courseWithDistanceAndScore.course
            } else {
                course = GPSArtCourse()
            }

            let courseData = CourseData(
                courseName: course.courseName,
                runningLength: course.courseLength,
                heading: course.heading,
                distance: course.distance,
                coursePaths: userLocations,
                runningCourseId: "",
                regionDisplayName: course.regionDisplayName,
                score: 0
            )

            let healthData = HealthData(
                totalTime: totalRunningInfo.totalTime,
                averageCadence: totalRunningInfo.totalStep / totalRunningInfo.totalTime * 60,
                totalRunningDistance: totalRunningInfo.totalDistance,
                totalEnergy: totalRunningInfo.kilocalorie,
                averageHeartRate: 0.0,
                averagePace: totalRunningInfo.totalTime / totalRunningInfo.totalDistance * 1000,
                startDate: runningStartTime,
                endDate: runningEndTime
            )

            let newRunningRecord = RunningRecord(
                id: UUID().uuidString,
                runningType: environmentStateManager.runningType,
                courseData: courseData,
                healthData: healthData
            )

            self.userDataModel.createRunningRecord(record: newRunningRecord) { result in
                   switch result {
                   case .success:
                       self.userLocations = []
                       self.showCompleteSheet = true
                       continuation.resume()
                   case .failure(let error):
                       print("Error saving running record: \(error)")
                       self.showCompleteSheet = true
                       continuation.resume()
                   }
               }
        }
    }
}

private extension RunningViewModel {
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

    func updateLiveActivity(newTotalDistance: String, newTotalTime: String, newPace: String, newHeartrate: String) {
        Task {
            guard let activityID = activityID,
                  let runningActivity = Activity<RunningAttributes>.activities.first(where: { $0.id == activityID }) else {
                return
            }
            if #available(iOS 16.2, *) {
                Task.detached {
                    print("update \(activityID)")
                    let newState = RunningAttributes.ContentState(totalDistance: newTotalDistance, totalTime: newTotalTime, pace: newPace, heartrate: newHeartrate)
                    print("newState \(newState)")
                    await runningActivity.update(.init(state: newState, staleDate: nil))
                }
            }
        }
    }

    func removeActivity() async {
        guard let activityID = activityID,
              let runningActivity = Activity<RunningAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        if #available(iOS 16.2, *) {
            let initialContentState = RunningAttributes.ContentState( totalDistance: String(self.totalRunningInfo.totalDistance), totalTime: String(self.totalRunningInfo.totalTime), pace: String(self.pedometerInfo.pace), heartrate: "--")

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
}

// Timer
private extension RunningViewModel {
    func startTimer() {
        timer = Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.time += 1
            }
    }

    func stopTimer() {
        timer?.cancel()
    }

    func formattedTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
