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
        timer = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.counter += 1
            }
    }
    
    func stopTimer() {
        /// 옵셔널 체이닝, nil 이 아닌 경우에만 호출
        timer?.cancel()
    }
}

extension DigitalTimerViewModel {
    
    /// 0.01 초 단위로 올라간 숫자를 00:00:00 타이머 형태로 변환해주는 함수입니다.
    /// - Parameter counter: Int 값을 넣어주세요
    /// - Returns: 00:00:00 타이머 형태
    func formattedTime(_ counter: Int) -> String {
        let minutes = counter / 6000
        let seconds = counter / 100 % 60
        let milliseconds = counter % 100
        
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
}
