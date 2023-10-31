//
//  FunctionManager.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/20/23.
//

import Foundation
import CoreLocation

final class ConvertCoordinateManager {
    static func convertToCLLocationCoordinates(_ coordinates: [Coordinate]) -> [CLLocationCoordinate2D] {
        return coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    static func convertToCLLocationCoordinate(_ coordinate: Coordinate) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
