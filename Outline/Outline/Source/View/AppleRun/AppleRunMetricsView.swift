//
//  AppleRunMetricsView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import SwiftUI

struct AppleRunMetricsView: View {
    @StateObject private var appleRunManager = AppleRunManager.shared
    private let weight: Double = 60
    
    var showDetail: Bool
    var isPaused: Bool
    
    var body: some View {
        VStack {
            if showDetail {
                VStack(spacing: 25) {
                    Text(formattedTime(appleRunManager.counter))
                        .font(.customTimeTitle)
                        .foregroundStyle(.customPrimary)
                    metricGrid
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            HStack {
                VStack(alignment: .center) {
                    Text(formattedTime(appleRunManager.counter))
                        .font(.customTitle)
                    Text("진행시간")
                        .font(.customCaption)
                        .foregroundStyle(.gray400)
                }
                .padding(.leading, 40)
                Spacer()
            }
            .opacity(!isPaused && !showDetail ? 1 : 0)
        }
    }
    
    private var metricGrid: some View {
        VStack(spacing: 25) {
            let totalDistance = appleRunManager.distance
            let steps = appleRunManager.steps
            let currentPace = appleRunManager.pace
            let distanceKM = totalDistance / 1000
            let kilocalorie = appleRunManager.kilocalorie
            
            HStack {
                MetricItem(value: String(format: "%.2f", distanceKM), label: "킬로미터")
                MetricItem(value: String(format: "%.0f", steps), label: "걸음수")
            }
            HStack {
                MetricItem(value: String(format: "%.0f", kilocalorie), label: "칼로리")
                MetricItem(value: currentPace.formattedCurrentPace(), label: "페이스")
            }
        }
    }
    
    private func formattedTime(_ counter: Int) -> String {
        let minutes = counter / 60
        let seconds = counter % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    AppleRunMetricsView(showDetail: true, isPaused: true)
}
