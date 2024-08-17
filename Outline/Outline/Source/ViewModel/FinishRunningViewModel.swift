//
//  FinishRunningViewModel.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import CoreData
import CoreLocation
import SwiftUI

class FinishRunningViewModel: ObservableObject {
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isShowPopup = false
                }
            }
        }
    }
    @Published var navigateToShareMainView = false
    @Published var userLocations: [CLLocationCoordinate2D] = []
    
    private var runningDate = Date()
    private let userDataModel = UserDataModel()
    
    var courseName: String = ""
    var regionDisplayName: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var date: String = ""
    var cardType: CardType = .great
    
    var runningData: [RunningDataItem] = [
        RunningDataItem(text: "킬로미터", data: ""),
        RunningDataItem(text: "시간", data: ""),
        RunningDataItem(text: "평균 페이스", data: ""),
        RunningDataItem(text: "BPM", data: ""),
        RunningDataItem(text: "칼로리", data: ""),
        RunningDataItem(text: "케이던스", data: ""),
        RunningDataItem(text: "점수", data: ""),
        RunningDataItem(text: "러닝타입", data: "")
    ]
    
    var shareData = ShareModel()
    
    func readData(runningRecord: FetchedResults<CoreRunningRecord>) {
        if let data = runningRecord.last,
           let courseData = data.courseData,
           let healthData = data.healthData {
            courseName = courseData.courseName ?? ""
            regionDisplayName = courseData.regionDisplayName ?? ""
            if let startDate = healthData.startDate {
                startTime = startDate.timeToString()
                date = startDate.dateToShareString()
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
            
            runningData[0].data = String(format: "%.2f", healthData.totalRunningDistance/1000)
            runningData[1].data = healthData.totalTime.formatMinuteSeconds()
            runningData[2].data = healthData.averagePace.formattedAveragePace()
            runningData[3].data = "\(Int(healthData.averageHeartRate))"
            runningData[4].data = "\(Int(healthData.totalEnergy))"
            runningData[6].data = "\(courseData.score)"
            getCardType(score: Int(courseData.score))
            if healthData.averageCadence > 0 {
                runningData[5].data = "\(Int(healthData.averageCadence))"
            } else {
                runningData[5].data = "0"
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
    
    func saveShareData() {
        shareData = ShareModel(
            courseName: courseName,
            runningDate: runningDate.dateToShareString(),
            regionDisplayName: regionDisplayName,
            distance: "\(runningData[0].data)km",
            cal: "\(runningData[4].data)Kcal",
            pace: "\(runningData[2].data)",
            bpm: "\(runningData[3].data)BPM",
            time: "\(runningData[1].data)",
            userLocations: userLocations
        )
        
        navigateToShareMainView = true
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
    
    func getCardType(score: Int) {
        switch score {
        case -1:
            cardType = .freeRun
        case 0...50:
            cardType = .nice
        case 51...80:
            cardType = .great
        case 81...100:
            cardType = .excellent
        default:
            cardType = .freeRun // Add a default case or handle as needed
        }
    }
}

struct RunningDataItem: Hashable {
    var id = UUID()
    var text: String
    var data: String
}
