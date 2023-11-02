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
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
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
                                .foregroundStyle(Color.first)
                        )
                    }
                    .buttonStyle(.plain)
                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            .opacity(phase.isIdentity ? 1 : 0.8)
                    }
                    .padding(.bottom, 8)
                    
                    if watchConnectivityManager.allCourses.isEmpty {
                        Text("OUTLINE iPhone을\n실행해서 경로를 제공받으세요.")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .foregroundStyle(.gray600)
                            .padding(.top, 32)
                    }
                    
                    ForEach(watchConnectivityManager.allCourses, id: \.id) {course in
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
                                    .foregroundStyle(.first)
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
                                        .foregroundStyle(.first, .clear)
                                        .font(.system(size: 30))
                                        .bold()
                                        .padding(8)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                            .foregroundStyle(.first)
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
            locationPermissionSheet
                .toolbar(.hidden, for: .navigationBar)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showFreeRunningGuideSheet) {
            freeRunningGuideSheet
                .toolbar(.hidden, for: .navigationBar)
                .ignoresSafeArea()
        }
        .onAppear {
            viewModel.checkAuthorization()
        }
    }
    
    private var locationPermissionSheet: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 43, height: 43)
                .foregroundStyle(Color.first)
            Spacer()
            Text("OUTLINE iPhone을 실행해서\n위치 권한을 허용해주세요.")
                .multilineTextAlignment(.center)
                .font(Font.system(size: 13))
            Spacer()
            Button {
                showLocationPermissionSheet.toggle()
            } label: {
                Text("확인")
            }
        }
    }
    
    private var freeRunningGuideSheet: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.thinMaterial)
            VStack {
                VStack(alignment: .leading) {
                    Text("자유 코스로 변경할까요?")
                    Text("현재 루트와 멀리 떨어져 있어요.")
                }
                .font(.system(size: 13))
                .padding()
                .padding(.top, 20)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                Button {
                    workoutManager.selectedWorkout = workoutTypes[0]
                    runningManager.startFreeRun()
                    showFreeRunningGuideSheet = false
                } label: {
                    Text("자유 코스로 변경")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.gray800.opacity(0.5))
                        )
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                Button {
                    showFreeRunningGuideSheet = false
                } label: {
                    Text("러닝 종료하기")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(Color.first)
                        )
                        .foregroundColor(.black)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 20)
            .overlay(alignment: .topLeading) {
                Image(systemName: "map.circle")
                    .font(.system(size: 42))
                    .foregroundColor(Color.first)
                    .padding(16)
                    .frame(width: 50, height: 50)
            }
            .toolbar(.hidden, for: .automatic)
            .padding()
        }
    }
}
