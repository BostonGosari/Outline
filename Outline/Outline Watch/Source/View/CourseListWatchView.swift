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
    
    @State private var detailViewNavigate = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: -5) {
                    Button {
                        workoutManager.selectedWorkout = workoutTypes[0]
                    } label: {
                        NavigationLink(destination: WatchTabView(), tag: workoutTypes[0], selection: $workoutManager.selectedWorkout) {
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
                    }
                    .buttonStyle(.plain)
                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            .opacity(phase.isIdentity ? 1 : 0.8)
                    }
                    
                    ForEach(testCourses) {course in
                        Button {
                            print("button clicked")
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
                                SampleCourePath()
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
            .navigationDestination(for: CourseInfo.self) { course in
                DetailView(courseInfo: course)
            }
            .onAppear {
                workoutManager.requestAuthorization()
            }
        }
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

struct CourseInfo: Hashable, Identifiable {
    let id = UUID().uuidString
    var locationInfo: String
    var courseName: String
    var courseLength: Double
    var courseDuration: Double
    var alley: String
}

let testCourses: [CourseInfo] = [
    CourseInfo(locationInfo: "포항시 남구 효자로1", courseName: "시티런", courseLength: 1, courseDuration: 30, alley: "많음"),
    CourseInfo(locationInfo: "포항시 남구 효자로2", courseName: "오리런", courseLength: 2, courseDuration: 40, alley: "적음"),
    CourseInfo(locationInfo: "포항시 남구 지곡로3", courseName: "보스런", courseLength: 3, courseDuration: 60, alley: "많음"),
    CourseInfo(locationInfo: "포항시 남구 효자로4", courseName: "턴고런", courseLength: 4, courseDuration: 70, alley: "보통"),
    CourseInfo(locationInfo: "포항시 남구 효자로5", courseName: "사리런", courseLength: 5, courseDuration: 80, alley: "많음")
]

struct DetailView: View {
    
    var courseInfo: CourseInfo
    
    var body: some View {
        List {
            listBox(systemName: "flag", context: courseInfo.locationInfo)
            listBox(systemName: "location", context: courseInfo.courseLength, specifier: "%.0f", unit: "km")
            listBox(systemName: "clock", duration: courseInfo.courseDuration)
            listBox(systemName: "arrow.triangle.turn.up.right.diamond", context: courseInfo.alley)
        }
        .navigationTitle {
            Text(courseInfo.courseName)
                .foregroundStyle(.green)
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

struct SampleCourePath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.68307*width, y: 0.03416*height))
        path.addCurve(to: CGPoint(x: 0.42506*width, y: 0.44577*height), control1: CGPoint(x: 0.48813*width, y: -0.03248*height), control2: CGPoint(x: 0.42984*width, y: 0.2808*height))
        path.addCurve(to: CGPoint(x: 0.0237*width, y: 0.61729*height), control1: CGPoint(x: 0.27097*width, y: 0.38861*height), control2: CGPoint(x: -0.02503*width, y: 0.34288*height))
        path.addCurve(to: CGPoint(x: 0.54969*width, y: 0.97047*height), control1: CGPoint(x: 0.06702*width, y: 0.86118*height), control2: CGPoint(x: 0.36077*width, y: 0.95024*height))
        path.addCurve(to: CGPoint(x: 0.66651*width, y: 0.91992*height), control1: CGPoint(x: 0.59191*width, y: 0.97499*height), control2: CGPoint(x: 0.63319*width, y: 0.95554*height))
        path.addLine(to: CGPoint(x: 0.91485*width, y: 0.65442*height))
        path.addCurve(to: CGPoint(x: 0.96734*width, y: 0.40077*height), control1: CGPoint(x: 0.97216*width, y: 0.59316*height), control2: CGPoint(x: 0.99871*width, y: 0.49034*height))
        path.addCurve(to: CGPoint(x: 0.68307*width, y: 0.03416*height), control1: CGPoint(x: 0.91588*width, y: 0.25382*height), control2: CGPoint(x: 0.82298*width, y: 0.08199*height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CourseListWatchView()
}
