//
//  ElapsedTimeView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        ZStack {
            ZStack {
                Text(NSNumber(value: elapsedTime), formatter: timeFormatter).offset(x: 2, y: 2)
                Text(NSNumber(value: elapsedTime), formatter: timeFormatter).offset(x: -2, y: -2)
                Text(NSNumber(value: elapsedTime), formatter: timeFormatter).offset(x: -2, y: 2)
                Text(NSNumber(value: elapsedTime), formatter: timeFormatter).offset(x: 2, y: -2)
            }
            .foregroundColor(Color.first)
            Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
                .foregroundColor(Color("Gray900"))
        } 
        .font(
            Font.custom("SF Pro Display", size: 40)
        )
        .onChange(of: showSubseconds) { value, _ in
            timeFormatter.showSubseconds = value
        }
    }
}

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }

        if showSubseconds {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }

        return formattedString
    }
}

#Preview {
    ElapsedTimeView()
}
