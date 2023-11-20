//
//  Route.swift
//  Outline
//
//  Created by hyebin on 11/15/23.
//

import Foundation

struct Route: Codable {
    let nextDirection: String
    let alertMessage: String
    let longitude: Double
    let latitude: Double
    let distance: Double
}
