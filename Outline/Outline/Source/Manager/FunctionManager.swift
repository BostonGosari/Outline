//
//  FunctionManager.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/20/23.
//

import Foundation
import CoreLocation

func formatDuration(_ durationInMinutes: Double) -> String {
    let hours = Int(durationInMinutes) / 60
    let minutes = Int(durationInMinutes) % 60
    return String(format: "%dh%02dm", hours, minutes)
}

func stringForCourseLevel(_ level: CourseLevel) -> String {
    switch level {
    case .easy:
        return "쉬움"
    case .normal:
        return "보통"
    case .hard:
        return "어려움"
    }
}

func stringForAlley(_ alley: Alley) -> String {
    switch alley {
    case .none:
        return "없음"
    case .few:
        return "적음"
    case .lots:
        return "많음"
    }
}

func convertToCLLocationCoordinates(_ coordinates: [Coordinate]) -> [CLLocationCoordinate2D] {
    return coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
}

func convertToCLLocationCoordinate(_ coordinate: Coordinate) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
}
