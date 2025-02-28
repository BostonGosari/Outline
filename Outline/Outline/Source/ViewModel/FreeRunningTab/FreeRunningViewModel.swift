//
//  FreeRunningViewModel.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/14/25.
//

import Combine
import MapKit
import SwiftUI

final class FreeRunningViewModel: ObservableObject {
    @AppStorage("authState") var authState: AuthState = .logout
    @Published var userLocation = ""
    @Published var progress: Double = 0.0
    @Published var isUnlocked = false
    @Published var freeRunCount: Int = 0

    private let connectivityManager = ConnectivityManager.shared
    private let locationManger = CLLocationManager()
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
                    Task {
                        if await self.checkAuthorization() {
                            self.environmentStateManager.startRunning()

                            let runningInfo = MirroringRunningInfo(runningType: .free, courseName: "자유아트", course: [])
                            self.connectivityManager.sendRunningInfo(runningInfo)
                        } else {
                            self.isUnlocked = false
                        }
                    }
                }
            }
            .store(in: &cancellable)
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
        if let location = locationManger.location {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let area = placemark.administrativeArea ?? ""
                    let city = placemark.locality ?? ""
                    let town = placemark.subLocality ?? ""

                    self.userLocation = "\(area) \(city) \(town)"
                }
            }
        }
    }

    private func checkAuthorization() async -> Bool {
        if await healthKitManager.checkAuthorization() == false {
            return false
        }
        if locationManager.checkLocationAuthorization() == false {
            return false
        }
        return true
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
