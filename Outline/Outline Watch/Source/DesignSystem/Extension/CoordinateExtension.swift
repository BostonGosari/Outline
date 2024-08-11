//
//  CoordinateExtension.swift
//  Outline Watch App
//
//  Created by hyunjun on 8/10/24.
//

import CoreLocation

extension Coordinate {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D {
    func toCoordinate() -> Coordinate {
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(_ coordinate: Coordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
