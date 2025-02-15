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
    @Published var showPermissionSheet = false
    @Published var isUnlocked = false
    @Published var permissionType: PermissionType = .health
    @Published var freeRunCount: Int = 0

    let connectivityManager = ConnectivityManager.shared
    let runningStartManager = RunningStartManager.shared
    var cancellable: Set<AnyCancellable> = Set()

    init() {
        $isUnlocked
            .sink { [weak self] newValue in
                guard let self else { return }
                if newValue {
                    if runningStartManager.checkAuthorization() {
                        runningStartManager.start = true
                        runningStartManager.startFreeRun()

                        let runningInfo = MirroringRunningInfo(runningType: .free, courseName: "자유아트", course: [])
                        connectivityManager.sendRunningInfo(runningInfo)
                    }
                    isUnlocked = false
                }
            }
            .store(in: &cancellable)
    }

    func onAppear() {
        userLocationToString()
        runningStartManager.getFreeRunNumber { result in
            switch result {
            case .success(let freeRunCount):
                self.freeRunCount = freeRunCount
            case .failure(let failure):
                print("fail to load freeRunCount \(failure)")
            }
        }
    }

    private func userLocationToString() {
        let locationManger = CLLocationManager()
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

}
