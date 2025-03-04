//
//  FreeRunningViewModel.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/14/25.
//

import Combine
import MapKit
import SwiftUI

@MainActor
final class FreeRunningViewModel: ObservableObject {
    @AppStorage("authState") var authState: AuthState = .logout
    @Published var userLocation = ""
    @Published var progress: Double = 0.0
    @Published var isUnlocked = false
    @Published var freeRunCount: Int = 0

    private let connectivityManager = ConnectivityManager.shared
    private var cancellable: Set<AnyCancellable> = Set()
    private let healthKitManager = HealthKitManager()
    private let locationManager = LocationManager()
    private let environmentStateManager = EnvironmentStateManager.shared
    private let userDataModel = UserDataModel()

    init() {
        $isUnlocked
            .sink { [weak self] newValue in
                guard let self else { return }
                if newValue {
                    startFreeRunning()
                }
            }
            .store(in: &cancellable)
    }

    func startFreeRunning() {
        Task {
            if await !healthKitManager.checkAuthorization() {
                environmentStateManager.showPermissionSheet(.health)
            } else if !locationManager.checkLocationAuthorization() {
                environmentStateManager.showPermissionSheet(.location)
            } else {
                self.environmentStateManager.startRunning(.free)

                let runningInfo = MirroringRunningInfo(runningType: .free, courseName: "자유아트", course: [])
                self.connectivityManager.sendRunningInfo(runningInfo)
            }
            self.isUnlocked = false
        }
    }

    func onAppear() {
        userLocationToString()
        getFreeRunNumber { result in
            switch result {
            case .success(let freeRunCount):
                self.freeRunCount = freeRunCount
            case .failure(let failure):
                print("fail to load freeRunCount \(failure)")
            }
        }
    }

    private func userLocationToString() {
        Task {
            let locationName = await locationManager.getLocationName()
            self.userLocation = locationName.regionDisplayName ?? ""
        }
    }

    private func getFreeRunNumber(completion: @escaping (Result<Int, CoreDataError>) -> Void) {
        userDataModel.getFreeRunCount { result in
            switch result {
            case .success(let freeRunCount):
                completion(.success(freeRunCount))
            case .failure(let failure):
                print("fail to read free run count \(failure)")
                completion(.failure(.dataNotFound))
            }
        }
    }
}
