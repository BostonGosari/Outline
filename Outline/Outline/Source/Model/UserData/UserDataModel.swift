//
//  UserDataModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
//

import CoreData
import SwiftUI
import CoreLocation

protocol UserDataModelProtocol {
    func createRunningRecord(
        record: RunningRecord,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    )
    func updateRunnningRecord(
        _ record: NSManagedObject,
        courseData: CourseData,
        healthData: HealthData,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    )
    func deleteRunningRecord(
        _ object: NSManagedObject,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    )
}
enum CoreDataError: Error {
    case saveFailed
}

struct UserDataModel: UserDataModelProtocol {
    let persistenceController = PersistenceController.shared
    
    private func saveContext() throws {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    func createRunningRecord(
        record: RunningRecord,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    ) {
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
        
        var pathList: [CoreCoordinate] = []
        for path in record.courseData.coursePaths {
            let newPath = CoreCoordinate(entity: CoreCoordinate.entity(), insertInto: persistenceController.container.viewContext)
            newPath.latitude = path.latitude
            newPath.longitude = path.longitude
            pathList.append(newPath)
        }
        
        newCourseData.coursePaths = NSSet(array: pathList)
        newCourseData.parentRecord = newRunningRecord
        
        let newHealthData = CoreHealthData(context: persistenceController.container.viewContext)
        newHealthData.setValue(record.healthData.totalTime, forKey: "totalTime")
        newHealthData.setValue(record.healthData.averageCyclingCadence, forKey: "averageCyclingCadence")
        newHealthData.setValue(record.healthData.totalRunningDistance, forKey: "totalRunningDistance")
        newHealthData.setValue(record.healthData.totalEnergy, forKey: "totalEnergy")
        newHealthData.setValue(record.healthData.averageHeartRate, forKey: "averageHeartRate")
        newHealthData.setValue(record.healthData.averagePace, forKey: "averagePace")
        
        newHealthData.recordHeathData = newRunningRecord
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
    
    func updateRunnningRecord(
        _ record: NSManagedObject,
        courseData: CourseData,
        healthData: HealthData,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    ) {
        guard let record = record as? CoreRunningRecord else {
            return
        }
        record.healthData?.setValue(healthData.totalTime, forKey: "totalTime")
        
        record.healthData?.setValue(healthData.averageCyclingCadence, forKey: "averageCyclingCadence")
        record.healthData?.setValue(healthData.totalRunningDistance, forKey: "totalRunningDistance")
        record.healthData?.setValue(healthData.totalEnergy, forKey: "totalEnergy")
        record.healthData?.setValue(healthData.averageHeartRate, forKey: "averageHeartRate")
        record.healthData?.setValue(healthData.averagePace, forKey: "averagePace")
        
        record.courseData?.setValue(courseData.courseName, forKey: "courseName")
        record.courseData?.setValue(courseData.runningDate, forKey: "runningDate")
        record.courseData?.setValue(courseData.startTime, forKey: "startTime")
        record.courseData?.setValue(courseData.endTime, forKey: "endTime")
        record.courseData?.setValue(courseData.heading, forKey: "heading")
        record.courseData?.setValue(courseData.distance, forKey: "distance")
        record.courseData?.setValue(courseData.courseLength ?? 0, forKey: "courseLength")
        record.courseData?.setValue(courseData.heading, forKey: "heading")
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
    
    func deleteRunningRecord(
        _ object: NSManagedObject,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    ) {
        persistenceController.container.viewContext.delete(object)
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
}
