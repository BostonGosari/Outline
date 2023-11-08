//
//  ShareModel.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import CoreLocation

struct ShareModel {
    var courseName: String
    var runningDate: String
    var regionDisplayName: String
    var distance: String
    var cal: String
    var pace: String
    var bpm: String
    var time: String
    var userLocations: [CLLocationCoordinate2D]
    
    init() {
        self.courseName = ""
        self.runningDate = ""
        self.regionDisplayName = ""
        self.distance = ""
        self.cal = ""
        self.pace = ""
        self.bpm = ""
        self.time = ""
        self.userLocations = []
    }
    
    init(courseName: String, runningDate: String, regionDisplayName: String, distance: String, cal: String, pace: String, bpm: String, time: String, userLocations: [CLLocationCoordinate2D]) {
        self.courseName = courseName
        self.runningDate = runningDate
        self.regionDisplayName = regionDisplayName
        self.distance = distance
        self.cal = cal
        self.pace = pace
        self.bpm = bpm
        self.time = time
        self.userLocations = userLocations
    }
}
