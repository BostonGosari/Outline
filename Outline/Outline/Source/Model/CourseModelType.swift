//
//  CourseModelType.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Foundation

typealias AllGPSArtCourses = [GPSArtCourse]

struct GPSArtCourse {
    let id = UUID().uuidString
    var courseName: String
    var locationInfo: Placemark
    var courseLength: Double
    var courseDuration: Double
    var centerLocation: Coordinate
    var distance: Double
    var level: Level
    var alley: Alley
    var coursePathes: [Coordinate]
    var heading: Double
    var mapScale: Double
}

struct Placemark {
    var name: String
    var isoCountryCode: String
    var administrativeArea: String
    var subAdministrativeArea: String
    var locality: String
    var subLocality: String
    var throughfare: String
    var subThroughfare: String
}
enum Level {
    case easy
    case normal
    case hard
}

enum Alley {
    case none
    case few
    case lots
}
