//
//  BigCardView.swift
//  Outline
//
//  Created by hyunjun on 10/30/23.
//

import SwiftUI
import Kingfisher

struct BigCardView: View {
    
    var course: CourseWithDistanceAndScore
    @Binding var loading: Bool
    var index: Int
    var currentIndex: Int
    var namespace: Namespace.ID
    var showDetailView: Bool
    
    private let courseScoreModel = CourseScoreModel()
    private let capsuleWidth: CGFloat = 70
    private let capsuleHeight: CGFloat = 25
    
    var body: some View {
        if showDetailView {
            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                .frame(
                    width: UIScreen.main.bounds.width * 0.84,
                    height: UIScreen.main.bounds.width * 0.84 * 1.5
                )
                .foregroundStyle(.gray700)
        } else {
            ZStack {
                KFImage(URL(string: course.course.thumbnail))
                    .resizable()
                    .placeholder {
                        UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70, style: .circular)
                            .foregroundStyle(.gray700)
                            .onDisappear {
                                loading = false
                            }
                    }
                    .matchedGeometryEffect(id: course.id, in: namespace)
                    .mask {
                        UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                    }
                    .shadow(color: .white, radius: 1, y: -1)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.84,
                        height: UIScreen.main.bounds.width * 0.84 * 1.5
                    )
                    .overlay(alignment: .topLeading) {
                        if !loading {
                            ScoreStar(score: course.score, size: .big)
                                .padding(24)
                        }
                    }
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
            .transition(
                .asymmetric(
                    insertion: .opacity.animation(.spring()),
                    removal: .opacity.animation(.spring().delay(0.3))
                )
            )
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
            .padding(.bottom, 11)
            HStack(spacing: 8) {
                Text("#\(course.course.courseLength, specifier: "%.0f")km")
                    .font(.customTag)
                    .foregroundColor(Color.customPrimary)
                Text("#\(course.course.courseDuration.formatDurationInKorean())")
                    .font(.customTag)
                   
            }
            .padding(.bottom, 19)
        }
        .padding(.vertical, 24)
        .padding(.leading, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
