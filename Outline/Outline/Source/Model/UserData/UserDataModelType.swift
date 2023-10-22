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
    var runningLength: Double
    var heading: Double
    var distance: Double
    var coursePaths: [CLLocationCoordinate2D]
    var runningCourseId: String
}

struct HealthData {
    var totalTime: Double
    var averageCadence: Double
    var totalRunningDistance: Double
    var totalEnergy: Double
    var averageHeartRate: Double
    var averagePace: Double
    var startDate: Date
    var endDate: Date
}
