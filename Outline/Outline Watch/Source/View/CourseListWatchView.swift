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
    @State private var showFreeRunningGuideSheet = false
    
    var workoutTypes: [HKWorkoutActivityType] = [.running]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: -5) {
                    Button {
                        if  viewModel.isHealthAuthorized && viewModel.isLocationAuthorized {
                            workoutManager.selectedWorkout = workoutTypes[0]
                            runningManager.startFreeRun()
                        } else {
                            if !viewModel.isLocationAuthorized {
                                showLocationPermissionSheet = true
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "play.circle.fill")
                            Text("자유러닝")
                        }
                        .foregroundColor(.black)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .foregroundStyle(.customPrimary)
                        )
                    }
                    .buttonStyle(.plain)
                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            .opacity(phase.isIdentity ? 1 : 0.8)
                    }
                    .padding(.bottom, 8)
                    
                    if connectivityManager.allCourses.isEmpty {
                        Text("OUTLINE iPhone을\n실행해서 경로를 제공받으세요.")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .foregroundStyle(.gray600)
                            .padding(.top, 32)
                    }
                    
                    ForEach(connectivityManager.allCourses, id: \.id) {course in
                        Button {
                            if viewModel.isHealthAuthorized && viewModel.isLocationAuthorized {
                                if runningManager.checkDistance(course: course.coursePaths) {
                                    workoutManager.selectedWorkout = workoutTypes[0]
                                    runningManager.startCourse = course
                                    runningManager.startGPSArtRun()
                                } else {
                                    showFreeRunningGuideSheet = true
                                }
                            }
                        } label: {
                            VStack {
                                Text(course.courseName)
                                    .padding(.leading, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                PathGenerateManager.caculateLines(width: 75, height: 75, coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(course.coursePaths))
                                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                    .scaledToFit()
                                    .frame(height: 75)
                                    .foregroundStyle(.customPrimary)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .foregroundStyle(.gray.opacity(0.2))
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
            .navigationTitle("러닝")
            .navigationDestination(isPresented: $navigateDetailView) {
                CourseDetailView(course: selectedCourse)
            }
        }
        .sheet(isPresented: $showLocationPermissionSheet) {
            PermissionSheet(type: .location)
                .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showFreeRunningGuideSheet) {
            TwoButtonSheet(text: "자유 코스로 변경할까요?\n현재 루트와 멀리 떨어져 있어요", firstLabel: "자유 코스로 변경", firstAction: {
                workoutManager.selectedWorkout = workoutTypes[0]
                runningManager.startFreeRun()
                showFreeRunningGuideSheet = false
            }, secondLabel: "돌아가기", secondAction: {
                showFreeRunningGuideSheet = false
            })
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            viewModel.checkAuthorization()
        }
    }
}
