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
    var distance: String
    var time: String
    var userLocations: [CLLocationCoordinate2D]
    var heading: Double
    
    init() {
        self.courseName = ""
        self.runningDate = ""
        self.distance = ""
        self.time = ""
        self.userLocations = []
        self.heading = 0
    }
    
    init(courseName: String, runningDate: String, distance: String, time: String, userLocations: [CLLocationCoordinate2D], heading: Double) {
        self.courseName = courseName
        self.runningDate = runningDate
        self.distance = distance
        self.time = time
        self.userLocations = userLocations
        self.heading = heading
    }
}
