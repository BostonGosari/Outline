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
            .font(Font.customHeadline)
            .monospacedDigit()
            .foregroundStyle(.customPrimary)
            .padding(.bottom)
    }
}

#Preview {
    ElapsedTimeView()
}
