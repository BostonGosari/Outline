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
    @Published var isNearEndLocation = false {
        didSet {
            if isNearEndLocation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.isNearEndLocation = false
                }
            }
        }
    }
    
    func checkEndDistance() {
        if checkAccuracy() >= 90 {
            if let lastLocation = userLocations.last {
                let location = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
                let startToDistance = location.distance(from: startLocation)
                
                if startToDistance <= 5 {
                    isShowComplteSheet = true
                } else if startToDistance <= 100 {
                    isNearEndLocation = true
                } else {
                    isNearEndLocation = false
                }
            }
        }
    }
    
    private func checkAccuracy() -> Double {
        let runningManager = RunningStartManager.shared
        
        if let course = runningManager.startCourse?.coursePaths {
            let guideCourse = ConvertCoordinateManager.convertToCLLocationCoordinates(course)
            let progressManager = CourseProgressManager(guideCourse: guideCourse, userCourse: userLocations)
            progressManager.calculate()
            return progressManager.getProgress()
        }
        return 0
    }
}
