//
//  RunningMapViewModel.swift
//  Outline
//
//  Created by hyebin on 10/17/23.
//

import CoreLocation
import SwiftUI

enum CurrentRunningType {
    case start
    case pause
    case stop
}

class RunningMapViewModel: ObservableObject {
    @Published var runningType: CurrentRunningType = .start
    @Published var isUserLocationCenter = false
    
    @Published var userLocations: [CLLocationCoordinate2D] = []
    @Published var startLocation = CLLocation()
   
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowPopup = false
                }
            }
        }
    }
    
    @Published var isShowComplteSheet = false
    @Published var isNearEndLocation = false
    
    var popupText: String {
        switch runningType {
        case .pause:
            return "일시정지를 3초동안 누르면 러닝이 종료돼요"
        case .start:
            return "도착점이 10m 이내에 있어요"
        default:
            return ""
        }
    }
    
    func checkEndDistance() {
        if checkAccuracy() >= 90 {
            if let lastLocation = userLocations.last {
                let location = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
                let startToDistance = location.distance(from: startLocation)
                
                if startToDistance <= 5 {
                    isShowComplteSheet = true
                } else if startToDistance <= 30 {
                    isNearEndLocation = true
                } else {
                    isNearEndLocation = false
                }
            }
        }
    }
    
    private func checkAccuracy() -> Double {
        let runningManager = RunningManager.shared
        
        if let course = runningManager.startCourse?.coursePaths {
            let guideCourse = ConvertCoordinateManager.convertToCLLocationCoordinates(course)
            let progressManager = CourseProgressManager(guideCourse: guideCourse, userCourse: userLocations)
            progressManager.calculate()
            return progressManager.getProgress()
        }
        return 0
    }
}
