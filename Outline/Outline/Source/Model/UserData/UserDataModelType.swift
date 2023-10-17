//
//  UserDataModelType.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
//

import CoreLocation
import SwiftUI

enum RunningType: String {
    case free
    case gpsArt
}

struct RunningRecord {
    var id: String
    var runningType: RunningType
    var courseData: CourseData
    var healthData: HealthData
}

struct CourseData {
    var courseName: String
    var runningDate: Date
    var startTime: Date
    var endTime: Date
    var heading: Double
    var distance: Double
    var coursePaths: [CLLocationCoordinate2D]
    var courseLength: Double?
}

struct HealthData {
    var totalTime: String
    var averageCyclingCadence: String
    var totalRunningDistance: String
    var totalEnergy: String
    var averageHeartRate: String
    var averagePace: String
}
