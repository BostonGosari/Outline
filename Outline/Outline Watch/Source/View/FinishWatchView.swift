//
//  FinishWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 10/19/23.
//

import SwiftUI

struct FinishWatchView: View {
    private let connectionWatchModel = ConnectingWatchModel()
    
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
            Text("PERFECT")
                .font(.system(size: 40))
                .foregroundStyle(.first)
                .bold()
                .offset(y: -40)
            Text("🎉")
                .font(.system(size: 64))
            Text("DRAWING")
                .font(.system(size: 40))
                .foregroundStyle(.first)
                .bold()
                .offset(y: 40)
        }
    }
    
    private var halfOrMoreCompletedView: some View {
        ZStack {
            Text("오늘은")
                .font(.system(size: 40))
                .foregroundStyle(.first)
                .bold()
                .offset(y: -40)
            Text("👋")
                .font(.system(size: 64))
            Text("여기까지")
                .font(.system(size: 40))
                .foregroundStyle(.first)
                .bold()
                .offset(y: 40)
        }
    }
    
    private var lessThanTenPercentCompletedView: some View {
        ZStack {
            Text("열심히")
                .font(.system(size: 40))
                .foregroundStyle(.first)
                .bold()
                .offset(y: -40)
            Text("❤️‍🔥")
                .font(.system(size: 64))
            Text("달렸네요")
                .font(.system(size: 40))
                .foregroundStyle(.first)
                .bold()
                .offset(y: 40)
        }
    }
}

#Preview {
    FinishWatchView(completionPercentage: 100.0)
}
