//
//  UserModelType.swift
//  Outline
//
//  Created by Seungui Moon on 10/15/23.
//

import Foundation

typealias UserList = [User]

struct User {
    let uid = UUID().uuidString
    var userInfo: UserInfo
    var userData: UserData
}

struct UserInfo: Hashable, Codable {
    var nickname: String
    var birthday: Date
    var height: Int
    var weight: Int
    var gender: Gender = .notSetted
}

struct UserData {
    var records: [Record]
    var currentRunningData: RunningData
}

enum Gender: String, Codable {
    case notSetted
    case man
    case woman
    case undefined
}

enum RunningType: String {
    case free
    case gpsArt
}

struct Record {
    var id = UUID().uuidString
    var courseName: String
    var runningType: RunningType
    var runningDate: Date
    var startTime: Date
    var endTime: Date
    var runningDuration: Date
    var courseLength: Double
    var runningLength: Double
    var averagePace: Date
    var calorie: Int
    var bpm: Int
    var cadence: Int
    var coursePaths: Coordinate
    var heading: Double
    var mapScale: Double
}

struct Coordinate {
    var longitude: Double
    var latitude: Double
}

struct RunningData {
    var currentTime: Double
    var currentLocation: Double
    var paceList: [Int]
    var bpmList: [Int]
}
