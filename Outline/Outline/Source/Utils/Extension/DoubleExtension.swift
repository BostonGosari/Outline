//
//  DoubleExtension.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import Foundation

extension Double {
    func formattedAveragePace() -> String {
        if self.isNaN {
            return "-'--''"
        }
        let minutes = Int(self / 60)
        let seconds = Int(self) % 60
        return String(format: "%02d'%02d''", minutes, seconds)
    }
    
    func formatDuration() -> String {
        let hours = Int(self) / 60
        let minutes = Int(self) % 60
        return String(format: "%dh%02dm", hours, minutes)
    }

    func formatMinuteSeconds() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    func formatHourMinuteSeconds() -> String {
        let hour = (Int(self) / 60) / 60
        let minutes = (Int(self) / 60) % 60
        let seconds = Int(self) % 60
        return String(format: "%2d:%2d:%02d", hour, minutes, seconds)
    }
}
