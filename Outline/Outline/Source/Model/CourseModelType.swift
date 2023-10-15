//
//  CourseModelType.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

typealias AllGPSArtCourses = [GPSArtCourse]

struct GPSArtCourse: Codable{
    var id: String
    var courseName: String
    var locationInfo: Placemark
    var courseLength: Double
    var courseDuration: Double
    var centerLocation: Coordinate
    var distance: Double
    var level: CourseLevel
    var alley: Alley
    var coursePathes: [Coordinate]
    var heading: Double
    var mapScale: Double
}

struct Placemark: Codable, Hashable {
    var name: String
    var isoCountryCode: String
    var administrativeArea: String
    var subAdministrativeArea: String
    var locality: String
    var subLocality: String
    var throughfare: String
    var subThroughfare: String
}
enum CourseLevel: String, Codable, Hashable {
    case easy
    case normal
    case hard
}

enum Alley: String, Codable, Hashable {
    case none
    case few
    case lots
}
