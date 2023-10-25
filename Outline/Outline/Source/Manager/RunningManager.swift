//
//  RunningManager.swift
//  Outline
//
//  Created by hyunjun on 10/25/23.
//

import Foundation

class RunningManager: ObservableObject {
    
    @Published var start = false
    @Published var running = false
    
    var startCourse: GPSArtCourse?
    var runningType: RunningType = .gpsArt
    
    static let shared = RunningManager()
    
    private init() {
    }
    
    func startFreeRun() {
        startCourse = GPSArtCourse()
        runningType = .free
    }
    
    func startGPSArtRun() {
        runningType = .gpsArt
    }
}
