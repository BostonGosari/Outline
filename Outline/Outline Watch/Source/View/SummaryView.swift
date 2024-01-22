//
//  SummaryView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var workoutManager = WatchWorkoutManager.shared
    @StateObject var runningManager = WatchRunningManager.shared
    
    @State private var isShowingFinishView = true
    @State private var timeFormatter = ElapsedTimeFormatter()
    @State private var progress = 0.0
    
    @Namespace var topID
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
                .ignoresSafeArea()
            
            if isShowingFinishView {
                FinishWatchView(score: runningManager.score)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isShowingFinishView = false
                        }
                    }
            } else {
                NavigationStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            CoordinatePathManager.createPath(width: 80, height: 80, coordinates: runningManager.userLocations)
                                .trim(from: 0, to: progress)
                                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                                .scaledToFit()
                                .foregroundStyle(.customPrimary)
                                .frame(width: 120, height: 120)
                                .onAppear {
                                    progress = 1.0
                                }
                                .animation(.bouncy(duration: 3), value: progress)
                                .overlay {
                                    ConfettiWatchView()
                                }
                            switch runningManager.score {
                               case 80...:
                                   Image("excellent")
                                       .resizable()
                                       .frame(width: 200)
                               case 50..<80:
                                   Image("great")
                                       .resizable()
                                       .frame(width: 200)
                               case 1..<50:
                                   Image("nice")
                                       .resizable()
                                       .frame(width: 200)
                               case 0:
                                Image("notyet")
                                    .resizable()
                                    .frame(width: 200)
                               default:
                                   // Handle no score case (optional)
                                    Text("그림을 완성했어요!")
                                    .padding(.vertical)
                               }
                           
                            Text(NSNumber(value: workoutManager.builder?.elapsedTime ?? 0), formatter: timeFormatter)
                                .id(topID)
                                .foregroundStyle(.customPrimary)
                                .font(.customHeadline)
                            
                            Text("총시간")
                                .font(.customBody)
                                .foregroundColor(Color.gray500)
                                .padding(.bottom, 24)
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 24) {
                                workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                                workoutDataItem(value: workoutManager.averagePace > 0
                                                ? workoutManager.averagePace.formattedAveragePace() : "-’--’’",
                                                label: "평균 페이스")
                                workoutDataItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                                workoutDataItem(value: "\(workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                            }
                            .padding(.bottom, 36)
                            Text("Outline 앱에서 전체 활동 기록을 확인하세요.")
                                .font(.customCaption2)
                                .foregroundColor(Color.gray500)
                                .padding(.bottom, 8)
                            Button {
                                runningManager.startRunning = false
                                workoutManager.showSummaryView = false
                                workoutManager.resetWorkout()
                            } label: {
                                Text("완료")
                                    .frame(height: 48)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(.gray800)
                                    }
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation(.easeInOut(duration: 2)) {
                                        proxy.scrollTo(topID, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle(runningManager.runningTitle)
                }
            }
        }
    }
}

extension SummaryView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color.gray500)
        }
    }
}
