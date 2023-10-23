//
//  FinishRunningViewModel.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import CoreLocation
import SwiftUI

class FinishRunningViewModel: ObservableObject {
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowPopup = false
                }
            }
        }
    }

    var courseName: String = ""
    var courseRegion: String = ""
    
    var startTime: String = ""
    var endTime: String = ""
    var date: String = ""
    
    var runningData: [RunningDataItem] = [
        RunningDataItem(text: "킬로미터", data: ""),
        RunningDataItem(text: "시간", data: ""),
        RunningDataItem(text: "평균 페이스", data: ""),
        RunningDataItem(text: "BPM", data: ""),
        RunningDataItem(text: "칼로리", data: ""),
        RunningDataItem(text: "케이던스", data: "")
    ]
    
    var userLocations: [CLLocationCoordinate2D] = []
  
    func readData(runningRecord: FetchedResults<CoreRunningRecord>) {
        if let data = runningRecord.last,
            let courseData = data.courseData,
            let healthData = data.healthData {
            courseName = courseData.courseName ?? ""
            courseRegion = ""
            
            if let startDate = healthData.startDate {
                startTime = startDate.timeToString()
                date = startDate.dateToString()
            } else {
                startTime = ""
                date = ""
            }
            
            if let endDate = healthData.endDate {
               endTime = endDate.timeToString()
            } else {
                endTime = ""
            }
            
            runningData[0].data = "\(healthData.totalRunningDistance)"
            runningData[1].data = "\(healthData.totalTime)"
            runningData[2].data = healthData.averagePace == 0 ? "-'--" : "\(healthData.averagePace)"
            runningData[3].data  = "\(healthData.averageHeartRate)"
            runningData[4].data  = "\(healthData.totalEnergy)"
            runningData[5].data = "\(healthData.averageCadence)"
            if let paths = courseData.coursePaths {
                var datas = [Coordinate]()
                paths.forEach { elem in
                    if let data = elem as? CoreCoordinate {
                        datas.append(Coordinate(longitude: data.longitude, latitude: data.latitude))
                    }
                }
                print(datas)
                userLocations = convertToCLLocationCoordinates(datas)
                print(userLocations)
            }
        } else {
            courseName = ""
            courseRegion = ""
            
            startTime = ""
            endTime = ""
            date = ""
            
            runningData = [
                RunningDataItem(text: "킬로미터", data: ""),
                RunningDataItem(text: "시간", data: ""),
                RunningDataItem(text: "평균 페이스", data: ""),
                RunningDataItem(text: "BPM", data: ""),
                RunningDataItem(text: "칼로리", data: ""),
                RunningDataItem(text: "케이던스", data: "")
            ]
            
            userLocations = []
        }
    }
}

struct RunningDataItem: Hashable {
    var id = UUID()
    var text: String
    var data: String
}
