//
//  MirroringControlsView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/22/23.
//

import MapKit
import SwiftUI

struct MirroringControlsView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    @State private var showEndRunningSheet = false
    @State private var showEndWithoutSavingSheet = false
    @State private var buttonAnimation = false
    @State private var dataAnimation = false
        
    var body: some View {
        ScrollView {
            HStack(spacing: 11) {
                ControlButton(systemName: "stop.fill", foregroundColor: .white, backgroundColor: .white) {

                }
                
                ControlButton(systemName: connectivityManager.runningState == .pause ? "pause" : "play.fill", foregroundColor: .customPrimary, backgroundColor: .customPrimary) {

                }
            }
            .padding(.top, buttonAnimation ? 20 : WKInterfaceDevice.current().screenBounds.height * 0.2)
            .padding(.bottom, connectivityManager.runningState == .pause ? 30 : 0)
            
            if connectivityManager.runningState != .pause {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 12) {
                    workoutDataItem(value: "\((connectivityManager.runningData.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                    workoutDataItem(value: connectivityManager.runningData.pace.formattedAveragePace(),
                                    label: "평균 페이스")
                    workoutDataItem(value: "\(connectivityManager.runningData.kcal.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                    workoutDataItem(value: "-", label: "BPM")
                }
                .padding(.bottom, 20)
                .opacity(dataAnimation ? 1 : 0)
            }
        }
        .scrollDisabled(connectivityManager.runningState == .pause)
        .sheet(isPresented: $showEndRunningSheet) {
            EndRunningSheet(text: "종료하시겠어요?") {
                connectivityManager.sendRunningState(.end)
            }
        }
        .sheet(isPresented: $showEndWithoutSavingSheet) {
            EndRunningSheet(text: "30초 이하는 기록되지 않아요.\n종료하시겠어요?") {
                connectivityManager.sendRunningState(.end)
            }
        }
    }
}

extension MirroringControlsView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .foregroundColor(.white)
                .font(.customLargeTitle)
                .foregroundColor(.white)
            Text(label)
                .font(.customBody)
                .foregroundColor(Color.gray500)
        }
    }
}

#Preview {
    MirroringControlsView()
}
