//
//  ArrayExtension.swift
//  Outline Watch App
//
//  Created by hyunjun on 8/10/24.
//

import SwiftUI
import CoreLocation

extension Array where Element == Coordinate {
    func toCLLocationCoordinates() -> [CLLocationCoordinate2D] {
        return self.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
}
