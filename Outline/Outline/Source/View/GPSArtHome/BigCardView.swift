//
//  BigCardView.swift
//  Outline
//
//  Created by hyunjun on 10/30/23.
//

import SwiftUI

struct BigCardView: View {
    
    var course: CourseWithDistance
    @Binding var loading: Bool
    var index: Int
    var currentIndex: Int
    var namespace: Namespace.ID
    var showDetailView: Bool
    
    var body: some View {
        AsyncImage(url: URL(string: course.course.thumbnail)) { image in
            if !showDetailView {
                image
                    .resizable()
                    .scaledToFill()
                    .roundedCorners(10, corners: [.topLeft])
                    .roundedCorners(70, corners: [.topRight])
                    .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: .white, radius: 1, y: -1)
            }
        } placeholder: {
            Rectangle()
                .foregroundColor(.gray700)
                .onDisappear {
                    loading = false
                }
                .roundedCorners(10, corners: [.topLeft])
                .roundedCorners(70, corners: [.topRight])
                .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
        }
        .matchedGeometryEffect(id: course.id, in: namespace)
        .frame(
            width: UIScreen.main.bounds.width * 0.84,
            height: UIScreen.main.bounds.height * 0.55
        )
        .transition(.identity)
        .overlay(alignment: .bottom) {
            if !loading {
                courseInformation
                    .opacity(index == currentIndex ? 1 : 0)
                    .offset(y: index == currentIndex ? 0 : 10)
                    .background(alignment: .bottom) {
                        Rectangle()
                            .foregroundStyle(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: .black.opacity(0), location: 0.00),
                                        Gradient.Stop(color: .black.opacity(0.7), location: 0.33),
                                        Gradient.Stop(color: .black.opacity(0.8), location: 1.00)
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                            .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
                            .opacity(index == currentIndex ? 1 : 0)
                            .offset(y: 10)
                    }
            }
        }
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(course.course.courseName)")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 8)
                .padding(.top, 47)
            HStack {
                Image(systemName: "mappin")
                Text("\(course.course.locationInfo.locality) \(course.course.locationInfo.subLocality) • 내 위치에서 \(course.distance/1000, specifier: "%.1f")km")
            }
            .font(.caption)
            .padding(.bottom, 16)
            HStack {
                Text("#\(course.course.courseLength, specifier: "%.0f")km")
                    .font(.tag2)
                    .foregroundColor(Color.customPrimary)
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                            .foregroundColor(Color.customPrimary)
                    }
                Text("#\(course.course.courseDuration.formatDuration())")
                    .frame(width: 70, height: 23)
                    .font(.tag2)
                    .background {
                        Capsule()
                            .stroke()
                    }
            }
        }
        .padding(.vertical, 36)
        .padding(.leading, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
