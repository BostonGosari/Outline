//
//  RunningRecord.swift
//  Outline
//
//  Modified by hyunjun on 8/10/24.
//

import CoreLocation
import SwiftUI

enum RunningType: String, Codable {
    case free
    case gpsArt
}

struct RunningRecord: Codable {
    var id: String
    var runningType: RunningType
    var courseData: CourseData
    var healthData: HealthData
}

struct CourseData: Codable {
    var courseName: String
    var runningLength: Double
    var heading: Double
    var distance: Double
    var coursePaths: [CLLocationCoordinate2D]
    var runningCourseId: String
    var regionDisplayName: String
    var score: Int?
}

struct HealthData: Codable {
    var totalTime: Double
    var averageCadence: Double
    var totalRunningDistance: Double
    var totalEnergy: Double
    var averageHeartRate: Double
    var averagePace: Double
    var startDate: Date
    var endDate: Date
}
