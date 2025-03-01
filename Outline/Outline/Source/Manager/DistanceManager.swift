//
//  DistanceManager.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/19/25.
//

import CoreLocation

final class DistanceManager {
    private let locationManager = CLLocationManager()
    // TODO: change course
    private let minDistance: CLLocationDistance = 1000000

    func checkDistance(course: [Coordinate]) -> Bool {

        guard let userLocation = locationManager.location?.coordinate else { return false }

        guard let shortestDistance = calculateShortestDistance(from: userLocation, to: course.toCLLocationCoordinates()) else { return false }

        return shortestDistance <= minDistance
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
