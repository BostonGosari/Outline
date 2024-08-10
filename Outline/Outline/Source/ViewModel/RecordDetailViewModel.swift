//
//  RecordDetailViewModel.swift
//  Outline
//
//  Created by hyebin on 10/24/23.
//

import CoreData
import CoreLocation
import SwiftUI

class RecordDetailViewModel: ObservableObject {
    @Published var navigateToShareMainView = false
    var courseRegion: String = ""
    var runningData = ["킬로미터": "", "시간": "", "평균 페이스": "", "BPM": "", "칼로리": "", "케이던스": "", "점수": ""]
    var userLocations: [CLLocationCoordinate2D] = []
    
    private var runningDate = Date()
    private let userDataModel = UserDataModel()
    
    var courseName: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var date: String = ""
    var regionDisplayName: String = ""
    var shareData = ShareModel()
    
    func readData(runningRecord: CoreRunningRecord) {
        if let courseData = runningRecord.courseData,
           let healthData = runningRecord.healthData {
            courseName = courseData.courseName ?? ""
            regionDisplayName = courseData.regionDisplayName ?? ""
            if let startDate = healthData.startDate {
                startTime = startDate.timeToString()
                date = startDate.dateToString()
                runningDate = startDate
            } else {
                startTime = ""
                date = ""
            }
            
            if let endDate = healthData.endDate {
               endTime = endDate.timeToString()
            } else {
                endTime = ""
            }
            
            runningData["킬로미터"] = String(format: "%.2f", healthData.totalRunningDistance/1000)
            runningData["시간"] = healthData.totalTime.formatMinuteSeconds()
            runningData["평균 페이스"] = healthData.averagePace.formattedAveragePace()
            runningData["BPM"] = "\(Int(healthData.averageHeartRate))"
            runningData["칼로리"] = "\(Int(healthData.totalEnergy))"
            runningData["점수"] = "\(courseData.score)"

            if healthData.averageCadence > 0 {
                runningData["케이던스"] = "\(Int(healthData.averageCadence))"
            } else {
                runningData["케이던스"] = "0"
            }
            
            if let paths = courseData.coursePaths {
                var datas = [Coordinate]()
                paths.forEach { elem in
                    if let data = elem as? CoreCoordinate {
                        datas.append(Coordinate(longitude: data.longitude, latitude: data.latitude))
                    }
                }
                userLocations = datas.toCLLocationCoordinates()
            }
        }
    }
    
    func deleteRunningRecord(_ record: NSManagedObject) {
        userDataModel.deleteRunningRecord(record) { result in
            switch result {
            case .success(let isSaved):
                print(isSaved)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateRunningRecord(_ record: NSManagedObject, courseName: String) {
        userDataModel.updateRunningRecordCourseName(record, newCourseName: courseName) { result in
            switch result {
            case .success(let isSaved):
                print(isSaved)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveShareData() {
        shareData = ShareModel(
            courseName: courseName,
            runningDate: runningDate.dateToShareString(),
            regionDisplayName: regionDisplayName,
            distance: "\(runningData["킬로미터"] ?? "0")km",
            cal: "\(runningData["칼로리"] ?? "0")Kcal",
            pace: "\(runningData["평균 페이스"] ?? "-'--")",
            bpm: "\(runningData["BPM"] ?? "0")BPM",
            time: "\(runningData["시간"] ?? "0")",
            userLocations: userLocations
        )
        
        navigateToShareMainView = true
    }
}
