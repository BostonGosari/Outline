//
//  CardDetailInformationView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit

struct CardDetailInformationView: View {
    
    var selectedCourse: CourseWithDistance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("#\(stringForCourseLevel(selectedCourse.course.level))")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                    .foregroundColor(.primaryColor)
                Text("\(selectedCourse.course.courseLength, specifier: "%.0f")km")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                Text("\(selectedCourse.course.courseDuration))")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
            }
            .fontWeight(.semibold)
            .font(.caption)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(selectedCourse.course.locationInfo.administrativeArea) \(selectedCourse.course.locationInfo.locality) \(selectedCourse.course.locationInfo.subLocality)")
                    .font(.title3)
                    .bold()
                Text("--")
                    .foregroundStyle(.gray)
            }
            
            Divider()
            
            Text("경로 정보")
                .font(.title3)
                .bold()
            VStack(alignment: .leading, spacing: 17) {
                HStack {
                    HStack {
                        Image(systemName: "location")
                        Text("거리")
                    }
                    .foregroundColor(.primaryColor)
                    Text("\(selectedCourse.course.courseLength, specifier: "%.0f")km")
                }
                HStack {
                    HStack {
                        Image(systemName: "clock")
                        Text("예상 소요 시간")
                    }
                    .foregroundColor(.primaryColor)
                    Text("\(selectedCourse.course.courseDuration.formatDuration())")
                }
                HStack {
                    HStack {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond")
                        Text("골목길")
                    }
                    .foregroundColor(.primaryColor)
                    Text(stringForAlley(selectedCourse.course.alley))
                }
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            Text("경로 지도")
                .font(.title3)
                .bold()
            VStack(alignment: .leading) {
                MapInfoView(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(selectedCourse.course.coursePaths))
                .frame(height: 200)
                .foregroundStyle(.thinMaterial)
                Text("경로 제작 고사리님 @alsgiwc")
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
    
    private func stringForCourseLevel(_ level: CourseLevel) -> String {
        switch level {
        case .easy:
            return "쉬움"
        case .normal:
            return "보통"
        case .hard:
            return "어려움"
        }
    }
    
    private func stringForAlley(_ alley: Alley) -> String {
        switch alley {
        case .none:
            return "없음"
        case .few:
            return "적음"
        case .lots:
            return "많음"
        }
    }
}
