//
//  FunctionManager.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/20/23.
//

import Foundation
import CoreLocation

func convertToCLLocationCoordinates(_ coordinates: [Coordinate]) -> [CLLocationCoordinate2D] {
    return coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
}

func convertToCLLocationCoordinate(_ coordinate: Coordinate) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
}
