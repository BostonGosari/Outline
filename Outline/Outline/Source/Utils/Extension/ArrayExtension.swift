//
//  ArrayExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 1/23/24.
//

import SwiftUI
import CoreLocation

extension Array where Element == Coordinate {
    func toCLLocationCoordinates() -> [CLLocationCoordinate2D] {
        return self.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
}
