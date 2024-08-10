//
//  ArrayExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 1/23/24.
//

import SwiftUI
import CoreLocation

struct Bound {
    var minLon: Double
    var maxLon: Double
    var minLat: Double
    var maxLat: Double
}

extension Array where Element == CLLocationCoordinate2D {
    func getBound() -> Bound {
        let longitudes = self.map { $0.longitude }
        let latitudes = self.map { $0.latitude }

        let minLon = longitudes.min() ?? 180
        let maxLon = longitudes.max() ?? -180
        let minLat = latitudes.min() ?? 90
        let maxLat = latitudes.max() ?? -90

        return Bound(minLon: minLon, maxLon: maxLon, minLat: minLat, maxLat: maxLat)
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
