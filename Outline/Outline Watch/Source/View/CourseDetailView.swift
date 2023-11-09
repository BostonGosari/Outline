//
//  CourseDetailView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/3/23.
//

import SwiftUI

struct CourseDetailView: View {
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
                .foregroundStyle(.customPrimary)
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, location: Placemark) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.customPrimary)
                .padding(.horizontal, 5)
            Text("\(location.administrativeArea) \(location.locality) \(location.subLocality)")
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, context: String) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.customPrimary)
                .padding(.horizontal, 5)
            Text(context)
        }
    }
    
    @ViewBuilder private func listBox(systemName: String, alley: Alley) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundStyle(.customPrimary)
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
