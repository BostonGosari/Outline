//
//  CourseListWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import HealthKit

struct CourseListWatchView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.running]
    @State private var countdownSeconds = 3 
    @State private var detailViewNavigate = false
    @Binding var navigate: Bool
    
    @State private var startCourse: GPSArtCourse = GPSArtCourse()
    
    @StateObject var watchConnectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: -5) {
                    Button {
                        workoutManager.selectedWorkout = workoutTypes[0]
                        navigate.toggle()
                    } label: {
                           HStack {
                               Image(systemName: "play.circle")
                               Text("자유러닝")
                                   .foregroundColor(.black)
                           }
                           .frame(height: 48)
                           .frame(maxWidth: .infinity)
                           .background(
                               RoundedRectangle(cornerRadius: 12, style: .continuous)
                                   .foregroundColor(.green)
                           )
                       }
                    .buttonStyle(.plain)
                    .navigationDestination(isPresented: $navigate, destination: {
                        countdownView()
                            .onAppear {
                                countdownSeconds = 3
                            }
                    })

                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            .opacity(phase.isIdentity ? 1 : 0.8)
                    }
                    .padding(.bottom, 8)
                    
                    if watchConnectivityManager.allCourses.isEmpty {
                        Text("경로를 받으시려면 Outline 앱을 켜주세요")
                    }
                    
                    ForEach(watchConnectivityManager.allCourses, id: \.id) {course in
                        Button {
                            print("button clicked")
                            startCourse = course
                            navigate = true
                        } label: {
                            VStack {
                                Text(course.courseName)
                                    .padding(.leading, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay(alignment: .trailing) {
                                        NavigationLink(value: course) {
                                            Image(systemName: "ellipsis")
                                                .font(.system(size: 24))
                                                .contentShape(Rectangle())
                                                .padding(20)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.trailing, -4)
                                    }
                                PathGenerateManager.shared.caculateLines(width: 75, height: 75, coordinates: convertToCLLocationCoordinates(course.coursePaths))
                                    .stroke(lineWidth: 4)
                                    .scaledToFit()
                                    .frame(height: 75)
                                    .foregroundColor(.green)
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
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                .opacity(phase.isIdentity ? 1 : 0.5)
                        }
                    }
                }
            }
            .navigationTitle("러닝")
            .navigationDestination(for: GPSArtCourse.self) { course in
                DetailView(course: course)
            }
            .onAppear {
                workoutManager.requestAuthorization()
            }
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
               WatchTabView(startCourse: startCourse) // 카운트다운이 끝나면 WatchTabView로 이동
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
                .foregroundStyle(.green)
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, location: Placemark) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.green)
                .padding(.horizontal, 5)
            Text("\(location.administrativeArea) \(location.locality) \(location.subLocality)")
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, context: String) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.green)
                .padding(.horizontal, 5)
            Text(context)
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, alley: Alley) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.green)
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

#Preview {
    CourseListWatchView(navigate: .constant(true))
}
