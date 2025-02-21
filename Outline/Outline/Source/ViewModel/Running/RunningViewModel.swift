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
final class RunningViewModel: ObservableObject {
    @AppStorage("isFirstRunning") var isFirstRunning = true
    /// 러닝 타임
    @Published var time = 0
    private var timer: AnyCancellable?

    /// Authorization
    @Published var permissionType: PermissionType?
    @Published var showPermissionSheet = false
    @Published var runningType: RunningType = .gpsArt

    /// 러닝 정보
    @Published var totalRunningInfo: TotalRunningInfo
    @Published var pedometerInfo: PedometerInfo
    @Published var userLocations: [CLLocationCoordinate2D] = []

    // LiveActivity
    @MainActor @Published private(set) var activityID: String?
    @MainActor @Published private(set) var activityToken: String?

    // View
    @Published var showCompleteSheet = false
    @Published var showStopPopup = false
    @Published var toggleMiniGuide = false

    private let distanceManager = DistanceManager()
    private let healthKitManager = HealthKitManager()
    private let locationManager = LocationManager()
    private let userDataModel = UserDataModel()
    private let pedometer = CMPedometer()
    private let connectivityManger = ConnectivityManager.shared
    private let environmentStateManager = EnvironmentStateManager.shared

    private var cancellable: Set<AnyCancellable> = Set()

    init() {
        self.totalRunningInfo = TotalRunningInfo()
        self.pedometerInfo = PedometerInfo()
    }
    func setupSink() {
        $time
            .sink { newValue in
//                if connectivityManger.isMirroring {
//                    let userLocations = locationManager.userLocations.map { $0.toCoordinate() }
//
//                    let runningData = MirroringRunningData(
//                        userLocations: userLocations,
//                        time: Double(newValue),
//                        distance: runningDataManager.distance,
//                        kcal: runningDataManager.kilocalorie,
//                        pace: runningDataManager.pace,
//                        bpm: 0
//                    )
//
//                    connectivityManger.sendRunningData(runningData)
//                }
            }
            .store(in: &cancellable)
    }

    func onAppear() {
//        locationManager.userLocations = []
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
        healthKitManager.endWorkout(steps: <#T##Double#>, distance: <#T##Double#>, energy: <#T##Double#>)
        saveRecord()
        reset()
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
    func saveRecord() {

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
                await
                runningActivity.update( using: newState)
            }
        }
    }

    func removeActivity() async {
        guard let activityID = await activityID,
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
