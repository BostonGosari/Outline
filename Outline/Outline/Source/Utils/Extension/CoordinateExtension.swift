//
//  CoordinateExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 1/23/24.
//

import CoreLocation

extension Coordinate {
    // Coordinate to CLLocationCoordinate2D
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(from clLocationCoordinate: CLLocationCoordinate2D) {
        self.init(longitude: clLocationCoordinate.longitude, latitude: clLocationCoordinate.latitude)
    }
}

extension CLLocationCoordinate2D {
    // CLLocationCoordinate2D to Coordinate
    func toCoordinate() -> Coordinate {
        return Coordinate(longitude: longitude, latitude: latitude)
    }

    init(from coordinate: Coordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension CLLocation {
    convenience init(from clLocationCoordinate: CLLocationCoordinate2D) {
        self.init(latitude: clLocationCoordinate.latitude, longitude: clLocationCoordinate.longitude)
    }
}
