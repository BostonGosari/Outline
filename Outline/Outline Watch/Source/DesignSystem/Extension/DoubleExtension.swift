//
//  DoubleExtension.swift
//  Outline Watch App
//
//  Created by hyunjun on 8/10/24.
//

import Foundation

extension Double {
    func formatMinuteSeconds() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func formattedCurrentPace() -> String {
        if self.isZero {
            return "-'--''"
        }
        
        let timeInSeconds = self * 1000  // 걸음 수를 1km로 환산
        let minutes = Int(timeInSeconds / 60)
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d'%02d''", minutes, seconds)
    }
    
    func formattedAveragePace() -> String {
        if self.isZero || self.isNaN || self.isInfinite {
            return "-'--''"
        }
        let minutes = Int(self / 60)
        let seconds = Int(self) % 60
        return String(format: "%d'%02d''", minutes, seconds)
    }
}
