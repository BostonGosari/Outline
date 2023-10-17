//
//  UserDataModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
//

import CoreData
import SwiftUI

struct UserDataModel {
    let persistenceController = PersistenceController.shared

    @FetchRequest (
        entity: RunningRecord.entity(), sortDescriptors: []
    ) var runningRecords: FetchedResults<RunningRecord>
    
    private func saveContext() {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
          print("Error saving managed object context: \(error)")
        }
    }
    
    func addRunningRecord(record: RunningRecord) {
        var newRunningRecord = RunningRecord(context: persistenceController.container.viewContext)
        newRunningRecord.courseData = record.courseData
        newRunningRecord.healthData = record.healthData
        newRunningRecord.runningType = record.runningType ?? ""

        saveContext()
    }
    
    
//    func readUserRecords() {}
//    func readUserRecord(id: String) {}
//    func updateOrCreateUserRecord(id: String, record: Record) {}
//    func deleteUserRecord(id: String) {}
}

//struct UserData {
//    var records: [Record]
//    var currentRunningData: RunningData
//}
//
//enum RunningType: String {
//    case freex5
//    case gpsArt
//}
//
//struct Record {
//    var id = UUID().uuidString
//    var courseName: String
//    var runningType: RunningType
//    var runningDate: Date
//    var startTime: Date
//    var endTime: Date
//    var runningDuration: Date
//    var courseLength: Double
//    var runningLength: Double
//    var averagePace: Date
//    var calorie: Int
//    var bpm: Int
//    var cadence: Int
//    var coursePaths: [Coordinate]
//    var heading: Double
//    var mapScale: Double
//}
//
//
//struct RunningData: Codable {
//    var currentTime: Double
//    var currentLocation: Double
//    var paceList: [Int]
//    var bpmList: [Int]
//}
