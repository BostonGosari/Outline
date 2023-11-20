//
//  CourseModelType.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

#if os(iOS)
import Firebase
import FirebaseFirestoreSwift
#endif
import SwiftUI

typealias AllGPSArtCourses = [GPSArtCourse]

struct GPSArtCourse: Codable, Hashable {
    var id: String
    var courseName: String
    var locationInfo: Placemark
    var courseLength: Double
    var courseDuration: Double
    var centerLocation: Coordinate
    var distance: Double
    var level: CourseLevel
    var alley: Alley
    var coursePaths: [Coordinate]
    var heading: Double
    var thumbnail: String
    var description: String
    var startLocation: Coordinate
    var regionDisplayName: String
    var producer: String
    var thumbnailLong: String
    var thumbnailNeon: String
    var title: String
    var navigation: [Navigation]
    var hotSpots: [HotSpot]
    
    
    init(
        id: String,
        courseName: String,
        locationInfo: Placemark,
        courseLength: Double,
        courseDuration: Double,
        centerLocation: Coordinate,
        distance: Double,
        level: CourseLevel,
        alley: Alley,
        coursePaths: [Coordinate],
        heading: Double,
        thumbnail: String,
        description: String = "",
        startLocation: Coordinate = Coordinate(longitude: 0, latitude: 0),
        regionDisplayName: String,
        producer: String = "",
        thumbnailLong: String = "",
        thumbnailNeon: String = "",
        title: String = "",
        navigation: [Navigation] = [],
        hotSpots: [HotSpot] = []
    ) {
        self.id = id
        self.courseName = courseName
        self.locationInfo = locationInfo
        self.courseLength = courseLength
        self.courseDuration = courseDuration
        self.centerLocation = centerLocation
        self.distance = distance
        self.level = level
        self.alley = alley
        self.coursePaths = coursePaths
        self.heading = heading
        self.thumbnail = thumbnail
        self.description = description
        self.startLocation = startLocation
        self.regionDisplayName = regionDisplayName
        self.producer = producer
        self.thumbnailLong = thumbnailLong
        self.thumbnailNeon = thumbnailNeon
        self.title = title
        self.navigation = navigation
        self.hotSpots = hotSpots
    }
    init() {
        self.id = ""
        self.courseName = ""
        self.locationInfo = Placemark(name: "", isoCountryCode: "", administrativeArea: "", subAdministrativeArea: "", locality: "", subLocality: "", throughfare: "", subThroughfare: "")
        self.courseLength = 0
        self.courseDuration = 0
        self.centerLocation = Coordinate(longitude: 0, latitude: 0)
        self.distance = 0
        self.level = .easy
        self.alley = .none
        self.coursePaths = []
        self.heading = 0
        self.thumbnail = ""
        self.description = ""
        self.startLocation = Coordinate(longitude: 0, latitude: 0)
        self.regionDisplayName = ""
        self.producer = "Outline"
        self.title = "default title"
        self.thumbnailLong = ""
        self.thumbnailNeon = ""
        self.navigation = []
        self.hotSpots = []
    }
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

struct Coordinate: Codable, Hashable {
    var longitude: Double
    var latitude: Double
}

struct Navigation: Codable, Hashable {
    var distance: Int
    var description: String
}

struct HotSpot: Codable, Hashable {
    var title: String
    var location: Coordinate
}
