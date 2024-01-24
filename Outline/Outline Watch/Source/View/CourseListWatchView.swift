//
//  CourseListWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import HealthKit
import UIKit

struct CourseListWatchView: View {
    @StateObject var workoutManager = WatchWorkoutManager.shared
    @StateObject var connectivityManager = WatchConnectivityManager.shared
    @StateObject var runningManager = WatchRunningManager.shared
    @StateObject var viewModel = CourseListWatchViewModel()
    
    @State private var navigateDetailView = false
    @State private var selectedCourse: GPSArtCourse = GPSArtCourse()
    @State private var showLocationPermissionSheet = false
    @State private var showNetworkErrorSheet = false
    @State private var showFreeRunningGuideSheet = false
    @State private var showMirroringSheet = false
    @State private var showMirroringView = false
    
    var workoutTypes: [HKWorkoutActivityType] = [.running]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if connectivityManager.allCourses.isEmpty {
                    EmptyContentView()
                } else {
                    ScrollView {
                        VStack(spacing: -5) {
                            freeArtButton
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                        .opacity(phase.isIdentity ? 1 : 0.8)
                                }
                            
                            ForEach(connectivityManager.allCourses, id: \.id) {course in
                                Button {
                                    if viewModel.isHealthAuthorized && viewModel.isLocationAuthorized {
                                        if runningManager.checkDistance(course: course.coursePaths) {
                                            workoutManager.selectedWorkout = workoutTypes[0]
                                            runningManager.startCourse = course
                                            runningManager.startGPSArtRun()
                                            
                                            let runningInfo = MirroringRunningInfo(runningType: .gpsArt, courseName: course.courseName, course: course.coursePaths)
                                            connectivityManager.sendRunningInfo(runningInfo)
                                        } else {
                                            if runningManager.locationNetworkError {
                                                showNetworkErrorSheet = true
                                            } else {
                                                showFreeRunningGuideSheet = true
                                            }
                                        }
                                    }
                                } label: {
                                    VStack {
                                        let coordinates = course.coursePaths.toCLLocationCoordinates()
                                        let canvasData = PathManager.getCanvasData(coordinates: coordinates, width: 80, height: 80)
                                        
                                        Text(course.courseName)
                                            .font(.customSubTitle)
                                            .padding(.leading, 4)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        PathManager.createPath(width: 80, height: 80, coordinates: coordinates)
                                            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                                            .frame(width: canvasData.width, height: canvasData.height)
                                            .foregroundStyle(.customPrimary)
                                            .frame(width: 80, height: 80)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 24)
                                            .foregroundStyle(.gray900)
                                    }
                                }
                                .buttonStyle(.plain)
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        selectedCourse = course
                                        navigateDetailView = true
                                    } label: {
                                        VStack {
                                            Image(systemName: "ellipsis.circle")
                                                .foregroundStyle(.customPrimary, .clear)
                                                .font(.system(size: 30))
                                                .bold()
                                                .padding(8)
                                            Spacer()
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .foregroundStyle(.customPrimary)
                                    .buttonStyle(.plain)
                                    .padding(.trailing, -4)
                                }
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                        .opacity(phase.isIdentity ? 1 : 0.5)
                                }
                            }
                        }
                    }
                    .navigationDestination(isPresented: $navigateDetailView) {
                        CourseDetailView(course: selectedCourse)
                    }
                    .sheet(isPresented: $showLocationPermissionSheet) {
                        PermissionSheet(type: .location)
                    }
                    .sheet(isPresented: $showNetworkErrorSheet) {
                        PermissionSheet(type: .network)
                    }
                    .sheet(isPresented: $showFreeRunningGuideSheet) {
                        TwoButtonSheet(
                            text: "자유 코스로 변경할까요?\n현재 루트와 멀리 떨어져 있어요",
                            firstLabel: "자유 코스로 변경",
                            firstAction: {
                                workoutManager.selectedWorkout = workoutTypes[0]
                                runningManager.startFreeRun()
                                showFreeRunningGuideSheet = false
                                
                                sendFreeRunningInfoToPhone()
                            },
                            secondLabel: "돌아가기",
                            secondAction: {
                                showFreeRunningGuideSheet = false
                            }
                        )
                        .toolbar(.hidden, for: .navigationBar)
                    }
                }
                
                if showMirroringView {
                    ZStack {
                        Color.black.ignoresSafeArea()
                        MirroringTabWatchView()
                    }
                }
            }
            .navigationTitle("아트")
            .onAppear {
                viewModel.checkAuthorization()
            }
            .onChange(of: connectivityManager.runningState) { _, newValue in
                if newValue == .start {
                    showMirroringSheet = true
                } else if newValue == .end {
                    showMirroringSheet = false
                    showMirroringView = false
                }
            }
            .sheet(isPresented: $showMirroringSheet) {
                TwoButtonSheet(
                    text: "iPhone으로 러닝을 그리고 있어요",
                    firstLabel: "돌아가기",
                    firstAction: {
                        showMirroringSheet = false
                    },
                    secondLabel: "미러링하기",
                    secondAction: {
                        showMirroringSheet = false
                        connectivityManager.sendIsMirroring(true)
                        showMirroringView = true
                    }
                )
            }
        }
    }
    
    private var freeArtButton: some View {
        Button {
            if  viewModel.isHealthAuthorized && viewModel.isLocationAuthorized {
                workoutManager.selectedWorkout = workoutTypes[0]
                runningManager.startFreeRun()
                
                sendFreeRunningInfoToPhone()
            } else {
                if !viewModel.isLocationAuthorized {
                    showLocationPermissionSheet = true
                }
            }
        } label: {
            HStack {
                Image(systemName: "play.circle.fill")
                Text("자유아트")
            }
            .font(.customButton)
            .foregroundColor(.black)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundStyle(.customPrimary)
            )
        }
        .buttonStyle(.plain)
        .padding(.bottom, 8)
    }
    
    private func sendFreeRunningInfoToPhone() {
        let runningInfo = MirroringRunningInfo(runningType: .free, courseName: "자유아트", course: [])
        connectivityManager.sendRunningInfo(runningInfo)
    }
}
