//
//  RunningViewModel.swift
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
    case gpsArt
    case freeRun
}

class RunningViewModel: ObservableObject {
    @Published var runningType: CurrentRunningType = .running
    @Published var mapType: CurrentMapType = .gpsArt
}
