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
    
    let coordinates: [CLLocationCoordinate2D] = {
        if let kmlFilePath = Bundle.main.path(forResource: "test", ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath)
        }
        return []
    }()
    
    func moveToUserLocation() {
        
    }
}
