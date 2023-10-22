//
//  DigitalTimerViewModel.swift
//  Outline
//
//  Created by hyunjun on 10/21/23.
//

import Foundation
import SwiftUI
import Combine

class DigitalTimerViewModel: ObservableObject {
    
    @Published var counter = 0
    
    private var timer: AnyCancellable?
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.counter += 1
            }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
}

extension DigitalTimerViewModel {
    
    /// 0.01 초 단위로 올라간 숫자를 00:00:00 타이머 형태로 변환해주는 함수입니다.
    /// - Parameter counter: Int 값을 넣어주세요
    /// - Returns: 00:00 타이머 형태
    func formattedTime(_ counter: Int) -> String {
        let minutes = counter / 60
        let seconds = counter % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
