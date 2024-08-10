//
//  RunningMetricsView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import Combine
import SwiftUI

struct RunningMetricsView: View {
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
                        .font(.customTimeTitle)
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
            .offset(y: getSafeArea().bottom == 0 ? 15 : 0)
            .opacity(!isPaused && !showDetail ? 1 : 0)
        }
        .onReceive(runningManager.$counter) { newCounterValue in
            if runningDataManager.activityID != nil {
                Task.detached {
                    // 시간이 바뀔 때마다 호출
                    await runningDataManager.updateLiveActivity(
                        newTotalDistance: String(format: "%.2f", (runningDataManager.totalDistance + runningDataManager.distance)/1000),
                        newTotalTime: runningManager.formattedTime(newCounterValue),
                        newPace: String(runningDataManager.pace.formattedCurrentPace()),
                        newHeartrate: "--"
                    )
                }
            }
            
        }
        .onChange(of: runningDataManager.distance) { _, _ in
            runningDataManager.kilocalorie = weight * (runningDataManager.totalDistance + runningDataManager.distance) / 1000 * 1.036
        }
    }
    
    private var metricGrid: some View {
        VStack(spacing: 25) {
            let totalDistance = runningDataManager.totalDistance + runningDataManager.distance
            let currentPace = runningDataManager.pace
            
            let distanceKM = totalDistance / 1000
            let kilocalorie = runningDataManager.kilocalorie
            
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
    RunningMetricsView(showDetail: false, isPaused: true)
}
