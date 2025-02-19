//
//  RunningViewModel.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/19/25.
//

import CoreLocation
import Combine
import SwiftUI


/// GPSArt, FreeRun 모두를 담당하는 Running을 관리하는 ViewModel
final class RunningViewModel: ObservableObject {
    /// 러닝 타임
    @Published var time = 0
    private var timer: AnyCancellable?

    /// Authorization
    @Published var permissionType: PermissionType?
    @Published var showPermissionSheet = false
    @Published var runningType: RunningType = .gpsArt

    private let distanceManager = DistanceManager()
    private let healthKitManager = HealthKitManager()
    private let locationManager = LocationManager()

    private let userDataModel = UserDataModel()

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

}

final class DistanceManager {
    private let locationManager = CLLocationManager()

    func checkDistance(course: [Coordinate]) -> Bool {

        guard let userLocation = locationManager.location?.coordinate else { return false }

        guard let shortestDistance = calculateShortestDistance(from: userLocation, to: course.toCLLocationCoordinates()) else { return false }

        return shortestDistance <= 50
    }

    /// 전체 코스에서 가장 짧은 거리를 계산하는 함수
    private func calculateShortestDistance(from userCoordinate: CLLocationCoordinate2D, to courseCoordinates: [CLLocationCoordinate2D]) -> CLLocationDistance? {
        guard !courseCoordinates.isEmpty else { return nil }

        var shortestDistance: CLLocationDistance?

        for courseCoordinate in courseCoordinates {
            let distanceToCourseCoordinate = calculateDistance(from: userCoordinate, to: courseCoordinate)
            if let currentShortestDistance = shortestDistance {
                shortestDistance = min(currentShortestDistance, distanceToCourseCoordinate)
            } else {
                shortestDistance = distanceToCourseCoordinate
            }
        }
        return shortestDistance
    }

    // 두 좌표 사이의 거리를 계산하는 함수
    private func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
}
