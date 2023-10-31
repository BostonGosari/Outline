//
//  TimerView.swift
//  Outline
//
//  Created by hyunjun on 10/21/23.
//

import SwiftUI

struct DigitalTimerView: View {
    
    private var runningManager = RunningManager.shared

    var body: some View {
        let timer = runningManager.counter
        
        Text(runningManager.formattedTime(timer))
            .font(Font.custom("Pretendard-ExtraBold", size: 70))
            .foregroundColor(.customPrimary)
            .monospacedDigit()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}

#Preview {
    DigitalTimerView()
}
