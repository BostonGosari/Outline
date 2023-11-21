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
    @Binding var selectedCourse: GPSArtCourse?
    @Binding var courseList: [GPSArtCourse]
    @Binding var showDetailView: Bool
    @Binding var category: String
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if loading {
                RoundedRectangle(cornerRadius: 9.5)
                    .padding(.leading, 16)
                    .foregroundColor(.gray700)
                    .frame(width: 148, height: 16)
            } else {
                Text(category)
                    .padding(.leading, 16)
                    .font(.customSubtitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, -5)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(courseList, id: \.id) { currentCourse in
                        ZStack {
                            Button {
                                withAnimation(.bouncy) {
                                    selectedCourse = currentCourse
                                    showDetailView = true
                                }
                            } label: {
                                ZStack {
                                    KFImage(URL(string: currentCourse.thumbnailLong))
                                        .resizable()
                                        .placeholder {
                                            Rectangle()
                                                .foregroundColor(.gray700)
                                                .onDisappear {
                                                    loading = false
                                                }
                                                .mask {
                                                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 30, style: .circular)
                                                }
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
                                        Text("\(currentCourse.courseName)")
                                            .font(.customHeadline)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 8)
                                        HStack(spacing: 0) {
                                            Image(systemName: "mappin")
                                                .foregroundColor(.gray600)
                                            Text("\(currentCourse.locationInfo.locality) \(currentCourse.locationInfo.subLocality)")
                                                .foregroundColor(.gray600)
                                        }
                                        .font(.customCaption)
                                        .padding(.bottom, 4)
                                        HStack(spacing: 8) {
                                            Text("#\(currentCourse.courseLength, specifier: "%.0f")km")
                                                .font(.customTag2)
                                                .foregroundColor(Color.customPrimary)
                                            Text("#\(currentCourse.courseDuration.formatDurationInKorean())")
                                                .font(.customTag2)
                                               
                                        }
                                        .padding(.bottom, 21)
                                    }
                                    .padding(.leading, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .matchedGeometryEffect(id: "\(currentCourse.id)_3", in: namespace)
                                .mask {
                                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 30, style: .circular)
                                }
                                .shadow(color: .white, radius: 0.5, y: -0.5)
                            }
                            .frame(
                                  width: UIScreen.main.bounds.width * 0.6,
                                  height: UIScreen.main.bounds.width * 1.2
                              )
                            .transition(.opacity)
                        }
                        .buttonStyle(CardButton())
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(UIScreen.main.bounds.width * 0.05)
        }
        .padding(.top, 48)
        .padding(.bottom, 160)
    }
}

#Preview {
    HomeTabView()
}
