//
//  Place.swift
//  Outline
//
//  Created by hyebin on 11/22/23.
//

import CoreLocation
import SwiftUI

struct Place: Identifiable, Hashable {
    let id: Int
    let title: String
    let spotDescription: String
    let location: CLLocationCoordinate2D
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
