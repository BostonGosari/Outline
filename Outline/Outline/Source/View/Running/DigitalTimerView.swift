//
//  TimerView.swift
//  Outline
//
//  Created by hyunjun on 10/21/23.
//

import SwiftUI

struct DigitalTimerView: View {
    
    @ObservedObject var digitalTimerViewModel: DigitalTimerViewModel

    var body: some View {
        let timer = digitalTimerViewModel.counter
        
        Text(digitalTimerViewModel.formattedTime(timer))
            .font(
                Font.custom("Pretendard-ExtraBold", size: 64)
            )
            .foregroundColor(.primaryColor)
            .monospacedDigit()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}

#Preview {
    DigitalTimerView(digitalTimerViewModel: DigitalTimerViewModel())
}
