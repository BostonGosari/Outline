//
//  FinishWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 10/19/23.
//

import SwiftUI

struct FinishWatchView: View {
    
    @State var completionPercentage: Double = 100

    var body: some View {
        ZStack {
            switch completionPercentage {
            case 100:
                fullyCompletedView
            case 50..<100:
                halfOrMoreCompletedView
            case ..<10:
                lessThanTenPercentCompletedView
            default:
                Text("\(completionPercentage, specifier: "%.2f")%")
            }
        }
    }
    
    private var fullyCompletedView: some View {
        ZStack {
            strokeText(text: "PERFECT", width: 2)
                .font(.system(size: 40))
                .bold()
                .offset(y: -40)
            Text("🎉")
                .font(.system(size: 64))
            strokeText(text: "DRAWING", width: 2)
                .font(.system(size: 40))
                .bold()
                .offset(y: 40)
        }
    }
    
    private var halfOrMoreCompletedView: some View {
        ZStack {
            strokeText(text: "오늘은", width: 2)
                .font(.system(size: 40))
                .bold()
                .offset(y: -40)
            Text("👋")
                .font(.system(size: 64))
            strokeText(text: "여기까지", width: 2)
                .font(.system(size: 40))
                .bold()
                .offset(y: 40)
        }
    }
    
    private var lessThanTenPercentCompletedView: some View {
        ZStack {
            strokeText(text: "열심히", width: 2)
                .font(.system(size: 40))
                .bold()
                .offset(y: -40)
            Text("❤️‍🔥")
                .font(.system(size: 64))
            strokeText(text: "달렸네요", width: 2)
                .font(.system(size: 40))
                .bold()
                .offset(y: 40)
        }
    }
    
    @ViewBuilder
    private func strokeText(text: String, width: CGFloat) -> some View {
        ZStack {
            ZStack {
                Text(text).offset(x: width, y: width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y: width)
                Text(text).offset(x: width, y: -width)
                Text(text).offset(x: 0, y: width)
                Text(text).offset(x: 0, y: -width)
                Text(text).offset(x: width, y: 0)
                Text(text).offset(x: -width, y: 0)
            }
            .foregroundColor(.green)
            Text(text)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    FinishWatchView(completionPercentage: 100.0)
}
