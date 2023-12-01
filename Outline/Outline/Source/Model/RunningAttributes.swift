//
//  RunningAttributes.swift
//  Outline
//
//  Created by 김하은 on 11/26/23.
//

import SwiftUI
import ActivityKit

struct RunningAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var totalDistance: String
        var totalTime: String
        var pace: String
        var heartrate: String
    }
    
    let runningText: String
}
