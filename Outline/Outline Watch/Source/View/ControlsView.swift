//
//  SwiftUIView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI
import UIKit

struct ControlsView: View {
    
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    @State private var showingConfirmation = false
    let startCourse: GPSArtCourse
        
    var body: some View {
        ZStack {
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
                            showingConfirmation = true
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
                ScrollView {
                    HStack(spacing: 14) {
                        Button {
                            showingConfirmation = true
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
                        workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                        workoutDataItem(value: workoutManager.pace > 0
                                        ? String(format: "%02d’%02d’’", Int(workoutManager.pace) / 60, Int(workoutManager.pace) % 60)
                                        : "-’--’’",
                                        label: "평균 페이스")
                        workoutDataItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                        workoutDataItem(value: "\(workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
                .navigationBarBackButtonHidden()
                .overlay(alignment: .topLeading) {
                    Text("일시정지됨")
                        .bold()
                        .foregroundStyle(.green)
                        .padding()
                        .padding(.top, 5)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            Rectangle()
                                .foregroundStyle(.thinMaterial)
                        }
                        .ignoresSafeArea()
                }
            }
        }
        .overlay {
            if showingConfirmation {
                customExitSheet()
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
                .font(.system(size: 24).weight(.semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color.gray500)
        }
    }
    
    private func customExitSheet() -> some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.thinMaterial)

            VStack {
                Spacer()
                Text("종료하시겠어요?")
                    .font(.headline)
                    .padding(.top, 20)
                Spacer()
               
                Button {
                    showingConfirmation = false
                } label: {
                    Text("계속 진행하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.gray800.opacity(0.5))
                        )
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                Button {
                    showingConfirmation = false
                    workoutManager.endWorkout()
                    let courseData = CourseData(courseName: startCourse.courseName, runningLength: startCourse.courseLength, heading: startCourse.heading, distance: startCourse.distance, coursePaths: convertToCLLocationCoordinates(startCourse.coursePaths), runningCourseId: "")

                    let healthData = HealthData(totalTime: 0.0, averageCadence: workoutManager.cadence, totalRunningDistance: workoutManager.distance, totalEnergy: workoutManager.calorie, averageHeartRate: workoutManager.heartRate, averagePace: workoutManager.pace, startDate: Date(), endDate: Date())

                    watchConnectivityManager.sendRunningRecordToPhone(RunningRecord(id: UUID().uuidString, runningType: .gpsArt, courseData: courseData, healthData: healthData))
                    
                } label: {
                    Text("종료하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.first)
                        )
                        .foregroundColor(.black)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        } 
        .ignoresSafeArea()
    }
}

//#Preview {
//    ControlsView().environmentObject(WatchWorkoutManager())
//}
