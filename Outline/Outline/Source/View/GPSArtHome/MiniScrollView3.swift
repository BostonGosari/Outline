//
//  MiniScrollView3.swift
//  Outline
//
//  Created by 김하은 on 10/20/23.
//

import SwiftUI
import MapKit
import Kingfisher

struct MiniScrollView3: View {
    @State private var loading = true
    @Binding var selectedCourse: CourseWithDistanceAndScore?
    @Binding var courseList: [CourseWithDistanceAndScore]
    @Binding var showDetailView: Bool
    @Binding var category: String
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
           
                Text(category)
                    .padding(.leading, 16)
                    .font(.customSubtitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
//                    .padding(.bottom, -5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(courseList, id: \.id) { currentCourse in
                        ZStack {
                            if showDetailView {
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.6,
                                        height: UIScreen.main.bounds.width * 1.2
                                    )
                            } else {
                                Button {
                                    withAnimation(.bouncy(duration: 0.7)) {
                                        selectedCourse = currentCourse
                                        showDetailView = true
                                    }
                                } label: {
                                    ZStack {
                                        KFImage(URL(string: currentCourse.course.thumbnailLong))
                                              .resizable()
                                               .scaledToFill()
                                               .frame(
                                                   width: UIScreen.main.bounds.width * 0.6,
                                                   height: UIScreen.main.bounds.width * 1.2
                                               )
                                               .clipped()
                                            
                                            .matchedGeometryEffect(id: currentCourse.id, in: namespace)
                                         
                                            .mask {
                                                UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 30)
                                            }
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: .black, location: 0.00),
                                                Gradient.Stop(color: .black.opacity(0), location: 1.00)
                                            ],
                                            startPoint: UnitPoint(x: 0.5, y: 0.9),
                                            endPoint: UnitPoint(x: 0.5, y: 0.1)
                                        )
                                        VStack(alignment: .leading, spacing: 0) {
                                            Spacer()
                                            Text("\(currentCourse.course.courseName)")
                                                .font(.customHeadline)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 8)
                                            HStack(spacing: 0) {
                                                Image(systemName: "mappin")
                                                    .foregroundColor(.gray600)
                                                Text("\(currentCourse.course.locationInfo.locality) \(currentCourse.course.locationInfo.subLocality)")
                                                    .foregroundColor(.gray600)
                                            }
                                            .font(.customCaption)
                                            .padding(.bottom, 4)
                                            HStack(spacing: 8) {
                                                Text("#\(currentCourse.course.courseLength, specifier: "%.0f")km")
                                                    .font(.customTag2)
                                                    .foregroundColor(Color.customPrimary)
                                                Text("#\(currentCourse.course.courseDuration.formatDurationInKorean())")
                                                    .font(.customTag2)
                                                
                                            }
                                            .padding(.bottom, 21)
                                        }
                                        .padding(.leading, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.6,
                                        height: UIScreen.main.bounds.width * 1.2
                                    )
                                    .mask {
                                        UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 30)
                                    }
                                    .shadow(color: .white, radius: 0.5, y: -0.5)
                                }
                                .buttonStyle(CardButton())
                                .frame(
                                    width: UIScreen.main.bounds.width * 0.6,
                                    height: UIScreen.main.bounds.width * 1.2
                                )
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
//            .padding(.top, 20)
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(UIScreen.main.bounds.width * 0.05)
        }
        .padding(.top, 48)
        .padding(.bottom, 120)
    }
}

#Preview {
    HomeTabView()
}
