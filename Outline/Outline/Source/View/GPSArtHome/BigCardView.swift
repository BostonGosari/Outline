//
//  BigCardView.swift
//  Outline
//
//  Created by hyunjun on 10/30/23.
//

import SwiftUI
import Kingfisher

struct BigCardView: View {
    var course: CourseWithDistance
    @Binding var loading: Bool
    var index: Int
    var currentIndex: Int
    var namespace: Namespace.ID
    var showDetailView: Bool
    
    private let capsuleWidth: CGFloat = 70
    private let capsuleHeight: CGFloat = 25
    
    var body: some View {
        KFImage(URL(string: course.course.thumbnail))
            .resizable()
            .placeholder {
                UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70, style: .circular)
                    .foregroundColor(.gray700)
                    .onDisappear {
                        loading = false
                    }
            }
            .matchedGeometryEffect(id: course.id, in: namespace)
            .mask {
                UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70, style: .circular)
            }
            .shadow(color: .white, radius: 1, y: -1)
            .frame(
                width: UIScreen.main.bounds.width * 0.84,
                height: UIScreen.main.bounds.width * 0.84 * 1.5
            )
            .transition(.opacity)
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
                        }
                }
            }
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(course.course.courseName)")
                .font(.customHeadline)
                .bold()
                .padding(.bottom, 8)
                .padding(.top, 47)
            HStack {
                Image(systemName: "mappin")
                Text("\(course.course.locationInfo.locality) \(course.course.locationInfo.subLocality) • 내 위치에서 \(course.distance/1000, specifier: "%.1f")km")
            }
            .font(.customCaption)
            .padding(.bottom, 16)
            HStack {
                Text("#\(course.course.courseLength, specifier: "%.0f")km")
                    .font(.customTag2)
                    .foregroundColor(Color.customPrimary)
                    .frame(width: capsuleWidth, height: capsuleHeight)
                    .background {
                        Capsule()
                            .stroke()
                            .foregroundColor(Color.customPrimary)
                    }
                Text("#\(course.course.courseDuration.formatDurationInKorean())")
                    .frame(width: capsuleWidth, height: capsuleHeight)
                    .font(.customTag2)
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
