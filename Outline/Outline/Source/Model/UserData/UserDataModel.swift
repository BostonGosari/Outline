//
//  UserDataModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
//

import CoreData
import SwiftUI
import CoreLocation

struct UserDataModel {
    let persistenceController = PersistenceController.shared
    var records: FetchRequest<CoreRunningRecord>
    
    private func saveContext() {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
          print("Error saving managed object context: \(error)")
        }
    }
    init() {
        records = FetchRequest<CoreRunningRecord>(entity: CoreRunningRecord.entity(), sortDescriptors: [])
    }
    
    func createCoordinate(coordinate: CLLocationCoordinate2D) {
        var newCoordinate = CoreCoordinate(context: persistenceController.container.viewContext)
        newCoordinate.setValue(coordinate.latitude, forKey: "latitude")
        newCoordinate.setValue(coordinate.longitude, forKey: "longitude")
    }
    
    func createRunningRecord(record: RunningRecord) {
        var newRunningRecord = CoreRunningRecord(context: persistenceController.container.viewContext)
        newRunningRecord.runningType = "free"
        newRunningRecord.id = UUID().uuidString
        
        let context = persistenceController.container.viewContext
        var newCourseData = CoreCourseData(context: context)
        newCourseData.setValue(record.courseData.courseName, forKey: "courseName")
        newCourseData.setValue(record.courseData.runningDate, forKey: "runningDate")
        newCourseData.setValue(record.courseData.startTime, forKey: "startTime")
        newCourseData.setValue(record.courseData.endTime, forKey: "endTime")
        newCourseData.setValue(record.courseData.heading, forKey: "heading")
        newCourseData.setValue(record.courseData.distance, forKey: "distance")
        newCourseData.setValue(record.courseData.courseLength ?? 0, forKey: "courseLength")
        newCourseData.setValue(record.courseData.heading, forKey: "heading")
//        
        newCourseData.parentRecord = newRunningRecord
////        for path in record.courseData.coursePathes {
////            let newPath = CoreCoordinate(entity: CoreCoordinate.entity(), insertInto: persistenceController.container.viewContext)
////            newPath.latitude = path.latitude
////            newPath.longitude = path.longitude
////        }
        var newHealthData = CoreHealthData(context: persistenceController.container.viewContext)
        newHealthData.setValue(record.healthData.totalTime, forKey: "totalTime")
        newHealthData.setValue(record.healthData.averageCyclingCadence, forKey: "averageCyclingCadence")
        newHealthData.setValue(record.healthData.totalRunningDistance, forKey: "totalRunningDistance")
        newHealthData.setValue(record.healthData.totalEnergy, forKey: "totalEnergy")
        newHealthData.setValue(record.healthData.averageHeartRate, forKey: "averageHeartRate")
        newHealthData.setValue(record.healthData.averagePace, forKey: "averagePace")
        
        newHealthData.recordHeathData = newRunningRecord
        
        saveContext()
    }
    
//    func readUserRecords() {}
//    func readUserRecord(id: String) {}
//    func updateOrCreateUserRecord(id: String, record: Record) {}
//    func deleteUserRecord(id: String) {}
}

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
    var coursePathes: [CLLocationCoordinate2D]
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
