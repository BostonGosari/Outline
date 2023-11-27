//
//  RunningAttributes.swift
//  Outline
//
//  Created by 김하은 on 11/26/23.
//

import SwiftUI
import ActivityKit

struct RunningAttributes: ActivityAttributes {
    struct ContentState : Codable, Hashable {
        var status: Status = .received
    }
    
    var totalDistance: Double
    var totalTime: Double
    var pace: Double
    var heartrate: Int
}

enum Status: String, CaseIterable, Codable, Equatable {
    case received = "shippingbox.fill"
    case progress = "person.bust"
    case ready = "takeoutbag.and.cup.and.straw.fill"
}
