//
//  SwiftUIView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    var body: some View {
        if workoutManager.running {
            VStack {
                Text("시티런")
                    .bold()
                    .foregroundStyle(.green)
                    .padding()
                    .padding(.top, 5)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .background {
                        Rectangle()
                            .foregroundStyle(.thinMaterial)
                    }
                Spacer()
                HStack(spacing: 14) {
                    Button {
                        workoutManager.endWorkout()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 24))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .foregroundColor(.white).opacity(0.5)
                            )
                    )
                    .frame(width: 80, height: 80)
                    .buttonStyle(.plain)
                    Button {
                        workoutManager.togglePause()
                    } label: {
                        Image(systemName: "pause")
                            .font(.system(size: 24))
                            .fontWeight(.black)
                            .foregroundColor(.first)
                            .padding()
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.first, lineWidth: 2)
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .foregroundColor(.first).opacity(0.5)
                            )
                        
                    )
                    .frame(width: 80, height: 80)
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 20)
                Spacer()
            }
            .ignoresSafeArea()
             
        } else {
            ZStack {
                ScrollView {
                    HStack(spacing: 14) {
                        Button {
                            workoutManager.endWorkout()
                        } label: {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 24))
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle()
                                        .foregroundColor(.white).opacity(0.5)
                                )
                        )
                        .frame(width: 80, height: 80)
                        .buttonStyle(.plain)
                        Button {
                            workoutManager.togglePause()
                        } label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 24))
                                .fontWeight(.black)
                                .foregroundColor(.first)
                                .padding()
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.first, lineWidth: 2)
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle()
                                        .foregroundColor(.first).opacity(0.5)
                                )
                        )
                        .frame(width: 80, height: 80)
                        .buttonStyle(.plain)
                        
                    }
                    .padding(.bottom, 24)
                    Spacer()
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 33) {
                        workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(1))))", label: "킬로미터")
                        workoutDataItem(value: "\(workoutManager.pace.formatted(.number.precision(.fractionLength(0))))", label: "평균 페이스")
                        workoutDataItem(value: "\(workoutManager.activeEnergy.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                        workoutDataItem(value: "\(workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
                VStack {
                    Text("일시정지됨")
                        .bold()
                        .foregroundStyle(.green)
                        .padding()
                        .padding(.top, 5)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background {
                            Rectangle()
                                .foregroundStyle(.thinMaterial)
                        }
                    Spacer()
                }
                .ignoresSafeArea()
            }
           
        }
    }
}

extension ControlsView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .foregroundColor(.white)
                .font(
                    Font.custom("SF Pro Display", size: 21)
                        .weight(.medium)
                    )
                .foregroundColor(.white)
            Text(label)
                .font(Font.custom("SF Pro Display", size: 11))
                .foregroundColor(Color.gray500)
        }
    }
}

#Preview {
    ControlsView().environmentObject(WatchWorkoutManager())
}
