//
//  MotionManager.swift
//  Outline
//
//  Created by hyunjun on 7/9/24.
//

import SwiftUI
import CoreMotion

final class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    private var manager: CMMotionManager
    
    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            if let motionData = motionData {
                withAnimation {
                    self.pitch = abs(motionData.attitude.pitch)
                    self.roll = abs(motionData.attitude.roll)
                }
            }
        }
        
    }
}
