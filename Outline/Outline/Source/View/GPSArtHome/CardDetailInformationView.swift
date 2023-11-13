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
    private let capsuleWidth: CGFloat = 87
    private let capsuleHeight: CGFloat = 28
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("#\(stringForCourseLevel(selectedCourse.course.level))")
                    .font(.customTag)
                    .frame(width: capsuleWidth, height: capsuleHeight)
                    .background {
                        Capsule()
                            .stroke()
                    }
                    .foregroundColor(.customPrimary)
                Text("#\(selectedCourse.course.courseLength, specifier: "%.0f")km")
                    .font(.customTag)
                    .frame(width: capsuleWidth, height: capsuleHeight)
                    .background {
                        Capsule()
                            .stroke()
                    }
                Text("#\(selectedCourse.course.courseDuration.formatDuration())")
                    .font(.customTag)
                    .frame(width: capsuleWidth, height: capsuleHeight)
                    .background {
                        Capsule()
                            .stroke()
                    }
            }
            .fontWeight(.semibold)
            .font(.customTag)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(selectedCourse.course.locationInfo.administrativeArea) \(selectedCourse.course.locationInfo.locality) \(selectedCourse.course.locationInfo.subLocality)")
                    .font(.customBody)
                Text("\(selectedCourse.course.description)")
                    .font(.customSubbody)
                    .foregroundStyle(.gray)
            }
            .padding(.bottom, -8)
            
            Divider()
            
            Text("경로 정보")
                .font(.customSubtitle)
                .fontWeight(.semibold)
            VStack(alignment: .leading, spacing: 17) {
                HStack {
                    HStack {
                        Image(systemName: "location")
                            .font(.system(size: 20))
                        Text("거리")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("\(selectedCourse.course.courseLength, specifier: "%.0f")km")
                        .font(.customSubbody)
                }
                HStack {
                    HStack {
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                        Text("예상 소요 시간")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("\(selectedCourse.course.courseDuration.formatDuration())")
                }
                HStack {
                    HStack {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond")
                            .font(.system(size: 20))
                        Text("골목길")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text(stringForAlley(selectedCourse.course.alley))
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 2)
            
            Divider()
            
            Text("경로 지도")
                .font(.customSubtitle)
                .fontWeight(.semibold)
            VStack(alignment: .leading, spacing: 8) {
                NavigationLink {
                    Map {
                        UserAnnotation()
                        MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(selectedCourse.course.coursePaths))
                            .stroke(.customPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    }
                    .mapControlVisibility(.hidden)
                    .toolbarBackground(.hidden, for: .navigationBar)
                } label: {
                    Map(interactionModes: []) {
                        UserAnnotation()
                        MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(selectedCourse.course.coursePaths))
                            .stroke(.customPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    }
                    .frame(height: 200)
                }
                .buttonStyle(.plain)
                Text("경로 제작 \(selectedCourse.course.producer)님")
                    .font(.customSubbody)
                    .foregroundStyle(.gray600)
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
