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
    
    func createRunningRecord(record: RunningRecord) {
        let newRunningRecord = CoreRunningRecord(context: persistenceController.container.viewContext)
        newRunningRecord.runningType = "free"
        newRunningRecord.id = UUID().uuidString
        
        let context = persistenceController.container.viewContext
        let newCourseData = CoreCourseData(context: context)
        newCourseData.setValue(record.courseData.courseName, forKey: "courseName")
        newCourseData.setValue(record.courseData.runningDate, forKey: "runningDate")
        newCourseData.setValue(record.courseData.startTime, forKey: "startTime")
        newCourseData.setValue(record.courseData.endTime, forKey: "endTime")
        newCourseData.setValue(record.courseData.heading, forKey: "heading")
        newCourseData.setValue(record.courseData.distance, forKey: "distance")
        newCourseData.setValue(record.courseData.courseLength ?? 0, forKey: "courseLength")
        newCourseData.setValue(record.courseData.heading, forKey: "heading")
        
//        var pathList: [CoreCoordinate] = []
//        for path in record.courseData.coursePathes {
//            let newPath = CoreCoordinate(entity: CoreCoordinate.entity(), insertInto: persistenceController.container.viewContext)
//            newPath.latitude = path.latitude
//            newPath.longitude = path.longitude
//            pathList.append(newPath)
//        }
//        
//        newCourseData.coursePathes = NSSet(object: pathList)
        newCourseData.parentRecord = newRunningRecord
        
        let newHealthData = CoreHealthData(context: persistenceController.container.viewContext)
        newHealthData.setValue(record.healthData.totalTime, forKey: "totalTime")
        newHealthData.setValue(record.healthData.averageCyclingCadence, forKey: "averageCyclingCadence")
        newHealthData.setValue(record.healthData.totalRunningDistance, forKey: "totalRunningDistance")
        newHealthData.setValue(record.healthData.totalEnergy, forKey: "totalEnergy")
        newHealthData.setValue(record.healthData.averageHeartRate, forKey: "averageHeartRate")
        newHealthData.setValue(record.healthData.averagePace, forKey: "averagePace")
        
        newHealthData.recordHeathData = newRunningRecord
        
        saveContext()
    }
    
    func deleteRunningRecord(_ object: NSManagedObject) {
        persistenceController.container.viewContext.delete(object)
        saveContext()
    }
    
//    func readUserRecords() {}
//    func readUserRecord(id: String) {}
//    func updateOrCreateUserRecord(id: String, record: Record) {}
//    func deleteUserRecord(id: String) {}
}
