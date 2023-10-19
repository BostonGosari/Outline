//
//  ShareModel.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import Foundation

struct ShareModel {
    var courseName: String
    var runningDate: String
    var runningregion: String
    var distance: String
    var cal: String
    var pace: String
    var bpm: String
    var time: String
    
    init(courseName: String, runningDate: String, runningregion: String, distance: String, cal: String, pace: String, bpm: String, time: String) {
        self.courseName = courseName
        self.runningDate = runningDate
        self.runningregion = runningregion
        self.distance = distance
        self.cal = cal
        self.pace = pace
        self.bpm = bpm
        self.time = time
    }
}
