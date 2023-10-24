//
//  UserDataModelType.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
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

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}
