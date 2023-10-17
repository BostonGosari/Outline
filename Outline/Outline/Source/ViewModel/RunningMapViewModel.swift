//
//  RunningMapViewModel.swift
//  Outline
//
//  Created by hyebin on 10/17/23.
//

import CoreLocation
import SwiftUI

enum CurrentRunningType {
    case running
    case pause
    case stop
}

enum CurrentMapType {
    case gpsArtRun
    case freeRun
}

class RunningMapViewModel: ObservableObject {
    @Published var runningType: CurrentRunningType = .running
    @Published var mapType: CurrentMapType = .gpsArtRun
    @Published var isUserLocationCenter = false
   
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowPopup = false
                }
            }
        }
    }
    
    var popupText: String {
        if runningType == .pause {
            "일시정지를 3초동안 누르면 러닝이 종료돼요"
        } else if runningType == .running {
            "도착점이 10m 이내에 있어요"
        } else {
            ""
        }
    }
    
    let coordinates: [CLLocationCoordinate2D] = {
        if let kmlFilePath = Bundle.main.path(forResource: "test", ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath)
        }
        return []
    }()
}
