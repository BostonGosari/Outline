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
    
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    @EnvironmentObject var locationManager: LocationManager

    var workoutTypes: [HKWorkoutActivityType] = [.running]
    @State private var countdownSeconds = 3 
    @State private var navigateDetailView = false
    @Binding var userLocations: [CLLocationCoordinate2D]
    @Binding var navigate: Bool
    
    @State var startCourse: GPSArtCourse = GPSArtCourse()
    
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: -5) {
                    Button {
                        if workoutManager.isHealthKitAuthorized && locationManager.isAuthorized {
                              workoutManager.selectedWorkout = workoutTypes[0]
                              navigate.toggle()
                          } else {
                              if !workoutManager.isHealthKitAuthorized {
                                  workoutManager.requestAuthorization()
                              } else if !locationManager.isAuthorized {
                                  locationManager.checkLocationAuthorizationStatus()
                              }
                              print("error")
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
                                .foregroundStyle(.first)
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
                            if workoutManager.isHealthKitAuthorized && locationManager.isAuthorized {
                                  workoutManager.selectedWorkout = workoutTypes[0]
                                  startCourse = course
                                  navigate.toggle()
                              } else {
                                  if !workoutManager.isHealthKitAuthorized {
                                      workoutManager.requestAuthorization()
                                  } else if !locationManager.isAuthorized {
                                      locationManager.checkLocationAuthorizationStatus()
                                  }
                                  print("error")
                              }
                        } label: {
                            VStack {
                                Text(course.courseName)
                                    .padding(.leading, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                PathGenerateManager.shared.caculateLines(width: 75, height: 75, coordinates: convertToCLLocationCoordinates(course.coursePaths))
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
                                startCourse = course
                                navigateDetailView.toggle()
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
            .navigationDestination(isPresented: $navigateDetailView) {
                DetailView(course: startCourse)
            }
            .navigationDestination(isPresented: $navigate) {
                countdownView()
                    .onAppear {
                        countdownSeconds = 3
                    }
            }
            .navigationTitle("러닝")
            .tint(.first)
        }
    }
    
    private func countdownView() -> some View {
       VStack {
           if countdownSeconds > 0 {
               Image("Count\(countdownSeconds)")
                   .resizable()
                   .scaledToFit()
                   .frame(maxWidth: .infinity, maxHeight: .infinity)  
                   .onAppear {
                       Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                           countdownSeconds -= 1
                           if countdownSeconds == 0 {
                               timer.invalidate()
                               workoutManager.selectedWorkout = .running
                           }
                       }
                   }
           } else {
               WatchTabView(userLocations: $userLocations, startCourse: startCourse) // 카운트다운이 끝나면 WatchTabView로 이동
           }
       }.navigationBarBackButtonHidden()
   }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .running:
            return "Run"
        default:
            return ""
        }
    }
}

struct DetailView: View {
    
    var course: GPSArtCourse
    
    var body: some View {
        List {
            listBox(systemName: "flag", context: course.locationInfo.locality)
            listBox(systemName: "location", context: course.courseLength, specifier: "%.0f", unit: "km")
            listBox(systemName: "clock", duration: course.courseDuration)
            listBox(systemName: "arrow.triangle.turn.up.right.diamond", alley: course.alley)
        }
        .navigationTitle {
            Text(course.courseName)
                .foregroundStyle(.first)
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, location: Placemark) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.first)
                .padding(.horizontal, 5)
            Text("\(location.administrativeArea) \(location.locality) \(location.subLocality)")
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, context: String) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.first)
                .padding(.horizontal, 5)
            Text(context)
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, alley: Alley) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.first)
                .padding(.horizontal, 5)
            switch alley {
            case .few:
                Text("적음")
            case .lots:
                Text("많음")
            case .none:
                Text("없음")
            }
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, context: Double, specifier: String, unit: String = "") -> some View {
        let formattedString = String(format: specifier + unit, context)
        listBox(systemName: systemName, context: formattedString)
    }
    
    private func listBox(systemName: String, duration: Double) -> some View {
        let hours = Int(duration) / 60
        let minutes = Int(duration) % 60
        
        let formattedString: String
        switch (hours, minutes) {
        case (0, _):
            formattedString = "\(minutes)m"
        case (_, 0):
            formattedString = "\(hours)h 00m"
        default:
            formattedString = "\(hours)h \(minutes)m"
        }
        
        return listBox(systemName: systemName, context: formattedString)
    }
    
}
