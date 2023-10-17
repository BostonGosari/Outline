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
    
    // 위도 경도로 거리를 계산하는 함수, 추후 업데이트 예정
    func calculateDistance(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D) -> Double {
        let earthRadius = 6371000.0 // Earth's radius in meters
        
        let lat1 = startCoordinate.latitude * .pi / 180.0
        let lon1 = startCoordinate.longitude * .pi / 180.0
        let lat2 = endCoordinate.latitude * .pi / 180.0
        let lon2 = endCoordinate.longitude * .pi / 180.0

        let dLat = lat2 - lat1
        let dLon = lon2 - lon1

        let first = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)
        let second = 2 * atan2(sqrt(first), sqrt(1 - first))

        let distance = earthRadius * second
        return distance
    }
}
