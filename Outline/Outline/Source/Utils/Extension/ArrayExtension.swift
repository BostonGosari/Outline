//
//  ArrayExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 1/23/24.
//

import SwiftUI
import CoreLocation

extension Array where Element == CLLocationCoordinate2D {
    func bounding() -> (minLon: Double, maxLon: Double, minLat: Double, maxLat: Double) {
        let longitudes = self.map { $0.longitude }
        let latitudes = self.map { $0.latitude }

        let minLon = longitudes.min() ?? 180
        let maxLon = longitudes.max() ?? -180
        let minLat = latitudes.min() ?? 90
        let maxLat = latitudes.max() ?? -90

        return (minLon, maxLon, minLat, maxLat)
    }
}

extension Array where Element == Coordinate {
    func toCLLocationCoordinates() -> [CLLocationCoordinate2D] {
        return self.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
}

extension Array where Element == CLLocationCoordinate2D {
    func toCoordinates() -> [Coordinate] {
        return self.map { Coordinate(longitude: $0.longitude, latitude: $0.latitude) }
    }
}
