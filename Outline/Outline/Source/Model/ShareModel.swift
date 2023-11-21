//
//  ShareModel.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import CoreLocation

struct ShareModel {
    var distance: String
    var cal: String
    var pace: String
    var time: String
    var userLocations: [CLLocationCoordinate2D]
    
    init() {
        self.distance = ""
        self.cal = ""
        self.pace = ""
        self.time = ""
        self.userLocations = []
    }
    
    init(distance: String, cal: String, pace: String, time: String, userLocations: [CLLocationCoordinate2D]) {
        self.distance = distance
        self.cal = cal
        self.pace = pace
        self.time = time
        self.userLocations = userLocations
    }
}
