//
//  NewRunningMetricsView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import SwiftUI

struct NewRunningMetricsView: View {
    @StateObject private var runningManager = RunningStartManager.shared
    @StateObject private var runningDataManager = RunningDataManager.shared
    
    // TODO: 사용자 데이터에서 가져오기
    private let weight: Double = 60
    
    var showDetail: Bool
    var isPaused: Bool
    
    var body: some View {
        VStack {
            if showDetail {
                VStack(spacing: 25) {
                    Text(runningManager.formattedTime(runningManager.counter))
                        .font(.customHeadline)
                        .foregroundStyle(.customPrimary)
                    metricGrid
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            HStack {
                VStack(alignment: .center) {
                    Text(runningManager.formattedTime(runningManager.counter))
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
        .onChange(of: runningDataManager.distance) { _, _ in
            runningDataManager.kilocalorie = weight * (runningDataManager.totalDistance + runningDataManager.distance) / 1000 * 1.036
        }
    }
    
    private var metricGrid: some View {
        VStack(spacing: 25) {
            let totalTime = runningDataManager.totalTime + runningDataManager.time
            let totalDistance = runningDataManager.totalDistance + runningDataManager.distance
            let currentPace = runningDataManager.pace
            
            let distanceKM = totalDistance / 1000
            let kilocalorie = runningDataManager.kilocalorie
            let cadence = totalTime != 0 ? ((runningDataManager.totalSteps + runningDataManager.steps) / totalTime * 60) : 0
            
            HStack {
                MetricItem(value: String(format: "%.2f", distanceKM), label: "킬로미터")
                //TODO: BPM 수정
                MetricItem(value: "--", label: "BPM")
                MetricItem(value: String(format: "%.0f", cadence), label: "케이던스")
            }
            HStack {
                MetricItem(value: String(format: "%.0f", kilocalorie), label: "칼로리")
                MetricItem(value: currentPace.formattedCurrentPace(), label: "평균 페이스")
                MetricItem(value: "000", label: "000")
                    .opacity(0)
            }
        }
    }
}

struct MetricItem: View {
    var value = "888'29''"
    var label = "평균 페이스"
    
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
    NewRunningMetricsView(showDetail: true, isPaused: true)
}
