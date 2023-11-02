//
//  ElapsedTimeView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .monospacedDigit()
            .foregroundColor(Color.first)
            .font(.system(size: 40, weight: .bold))
    }
}

#Preview {
    ElapsedTimeView()
}
