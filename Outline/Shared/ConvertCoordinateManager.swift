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
    
    static func convertToCoordinates(_ CLLocationCoordinates: [CLLocationCoordinate2D]) -> [Coordinate] {
        return CLLocationCoordinates.map { Coordinate(longitude: $0.longitude, latitude: $0.latitude) }
    }
    
    static func convertToCoordinate(_ CLLocationCoordinate: CLLocationCoordinate2D) -> Coordinate {
        return Coordinate(longitude: CLLocationCoordinate.longitude, latitude: CLLocationCoordinate.latitude)
    }
}
