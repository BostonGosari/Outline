//
//  RecordDetailViewModel.swift
//  Outline
//
//  Created by hyebin on 10/24/23.
//

import CoreLocation
import SwiftUI

class RecordDetailViewModel: ObservableObject {
    @Published var navigateToShareMainView = false
    @Published var courseRegion: String = ""
    @Published var runningData = ["킬로미터": "", "시간": "", "평균 페이스": "", "BPM": "", "칼로리": "", "케이던스": ""]
    
    private var runningDate = Date()
    var courseName: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var date: String = ""
    
    var shareData = ShareModel()
    
    var userLocations: [CLLocationCoordinate2D] = []
    
    func readData(runningRecord: CoreRunningRecord) {
        if let courseData = runningRecord.courseData,
           let healthData = runningRecord.healthData {
            courseName = courseData.courseName ?? ""
            
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
            
            runningData["킬로미터"] = "\(healthData.totalRunningDistance)"
            runningData["시간"] = "\(formattedTime(Int(healthData.totalTime)))"
            runningData["평균 페이스"] = healthData.averagePace == 0 ? "-'--" : "\(healthData.averagePace)"
            runningData["BPM"] = "\(healthData.averageHeartRate)"
            runningData["칼로리"] = "\(healthData.totalEnergy)"
            runningData["케이던스"] = "\(healthData.averageCadence)"
            
            if let paths = courseData.coursePaths {
                var datas = [Coordinate]()
                paths.forEach { elem in
                    if let data = elem as? CoreCoordinate {
                        datas.append(Coordinate(longitude: data.longitude, latitude: data.latitude))
                    }
                }
                userLocations = convertToCLLocationCoordinates(datas)
            }
            
            let geocoder = CLGeocoder()
            
            if let first = userLocations.first {
                let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
                geocoder.reverseGeocodeLocation(start) { placemarks, error in
                    if let error = error {
                        print("Reverse geocoding error: \(error.localizedDescription)")
                    } else if let placemark = placemarks?.first {
                        let area = placemark.administrativeArea ?? ""
                        let city = placemark.locality ?? ""
                        let town = placemark.subLocality ?? ""
                        
                        self.courseRegion = "\(area) \(city) \(town)"
                    }
                }
            }
        } else {
            courseName = ""
            courseRegion = ""
            
            startTime = ""
            endTime = ""
            date = ""
            
            runningData = ["킬로미터": "", "시간": "", "평균 페이스": "", "BPM": "", "칼로리": "", "케이던스": ""]
            
            userLocations = []
        }
    }
    
    func saveShareData() {
        shareData = ShareModel(
            courseName: courseName,
            runningDate: runningDate.dateToShareString(),
            runningRegion: courseRegion,
            distance: "\(runningData["킬로미터"] ?? "0")km",
            cal: "\(runningData["칼로리"] ?? "0")Kcal",
            pace: "\(runningData["평균 페이스"] ?? "-'--")",
            bpm: "\(runningData["BPM"] ?? "0")BPM",
            time: "\(runningData["시간"] ?? "0")",
            userLocations: userLocations
        )
        
        navigateToShareMainView = true
    }
    
    private func formattedTime(_ counter: Int) -> String {
        let minutes = counter / 60
        let seconds = counter % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
