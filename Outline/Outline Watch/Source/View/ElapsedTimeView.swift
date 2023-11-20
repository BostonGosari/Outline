//
//  ElapsedTimeView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct ElapsedTimeView: View {
    @State private var timeFormatter = ElapsedTimeFormatter()
    var elapsedTime: TimeInterval = 0

    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .monospacedDigit()
            .foregroundStyle(.customPrimary)
            .font(.system(size: 40, weight: .bold))
            .padding(.bottom)
    }
}

#Preview {
    ElapsedTimeView()
}
