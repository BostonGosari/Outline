//
//  RunningMetricsView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import Combine
import SwiftUI

struct RunningMetricsView: View {
    @EnvironmentObject private var viewModel: RunningViewModel
    
    var body: some View {
        VStack {
            if viewModel.showDetailMetrics {
                VStack(spacing: 25) {
                    Text(viewModel.formattedTimeText)
                        .font(.customTimeTitle)
                        .foregroundStyle(.customPrimary)
                    metricGrid
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            HStack {
                VStack(alignment: .center) {
                    Text(viewModel.formattedTimeText)
                        .font(.customTitle)
                    Text("진행시간")
                        .font(.customCaption)
                        .foregroundStyle(.gray400)
                }
                .padding(.leading, 40)
                Spacer()
            }
            .offset(y: getSafeArea().bottom == 0 ? 15 : 0)
            .opacity(!viewModel.isPaused && !viewModel.showDetailMetrics ? 1 : 0)
        }
    }
    
    private var metricGrid: some View {
        VStack(spacing: 25) {
            let totalRunningInfo = viewModel.totalRunningInfo
            let totalDistance = totalRunningInfo.totalDistance
            let currentPace = viewModel.pedometerInfo.pace

            let distanceKM = totalDistance / 1000
            let kilocalorie = totalRunningInfo.kilocalorie

            HStack {
                MetricItem(value: String(format: "%.2f", distanceKM), label: "킬로미터")
                MetricItem(value: "--", label: "BPM")
            }
            HStack {
                MetricItem(value: String(format: "%.0f", kilocalorie), label: "칼로리")
                MetricItem(value: currentPace.formattedCurrentPace(), label: "페이스")
            }
        }
       
    }
}

struct MetricItem: View {
    var value: String
    var label: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.customTitle)
            Text(label)
                .font(.customSubbody)
                .foregroundStyle(.gray200)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RunningMetricsView()
        .environmentObject(RunningViewModel())
}
