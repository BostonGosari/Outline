//
//  MirroringModel.swift
//  Outline
//
//  Created by hyunjun on 8/10/24.
//

import Foundation

enum MirroringRunningState: Codable {
    case start
    case pause
    case resume
    case end
}

struct MirroringRunningInfo: Codable {
    var runningType: RunningType = .free
    var courseName: String = ""
    var course: [Coordinate] = []
    var heading: Double = 0
}

struct MirroringRunningData: Codable {
    var userLocations: [Coordinate] = []
    var time: Double = 0
    var distance: Double = 0
    var kcal: Double = 0
    var pace: Double = 0
    var bpm: Double = 0
}
