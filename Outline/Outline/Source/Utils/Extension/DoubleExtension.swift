//
//  DoubleExtension.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import Foundation

extension Double {
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
    
    func formatDurationInKoreanDetail() -> String {
        let hours = Int(self) / 60
        let minutes = Int(self) % 60
        if hours == 0 {
            return String(format: "%02d분", minutes)
        } else {
            return String(format: "%d시간 %02d분", hours, minutes)
        }
    }
    
    func formatDurationInKorean() -> String {
        let hours = Int(self) / 60
        let minutes = Int(self) % 60
        if hours == 0 {
            return String("\(minutes)분대")
        }
        return String("\(hours)시간대")
    }
    
    func formatMinuteSeconds() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
