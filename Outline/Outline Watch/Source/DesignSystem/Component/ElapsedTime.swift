//
//  ElapsedTime.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct ElapsedTime: View {
    @State private var timeFormatter = ElapsedTimeFormatter()
    var time: TimeInterval = 0

    var body: some View {
        Text(NSNumber(value: time), formatter: timeFormatter)
            .font(Font.customHeadline)
            .monospacedDigit()
            .foregroundStyle(.customPrimary)
            .padding(.bottom)
    }
}

#Preview {
    ElapsedTime()
}
