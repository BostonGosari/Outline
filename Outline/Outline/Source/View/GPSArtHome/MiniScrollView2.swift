//
//  MiniScrollView1.swift
//  Outline
//
//  Created by 김하은 on 10/20/23.
//

import SwiftUI
import MapKit
import Kingfisher

struct MiniScrollView2: View {
    @State private var loading = true
    @Binding var selectedCourse: CourseWithDistanceAndScore?
    @Binding var courseList: [CourseWithDistanceAndScore]
    @Binding var showDetailView: Bool
    @Binding var category: String
    var namespace: Namespace.ID
    var zstackIndex: Int = 0
    
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
                    ForEach(Array(courseList.enumerated()), id: \.element.id) { (index, currentCourse) in
                        ZStack {
                            Button {
                                withAnimation(.bouncy) {
                                    selectedCourse = currentCourse
                                    showDetailView = true
                                }
                            } label: {
                                ZStack {
                                    KFImage(URL(string: currentCourse.course.thumbnail))
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
                                    VStack(alignment: .leading, spacing: 4) {
                                        ScoreStar(score: currentCourse.score, size: .small)
                                            .padding(.top, 12)
                                        Spacer()
                                        Text("\(currentCourse.course.courseName)")
                                            .font(Font.system(size: 20).weight(.semibold))
                                            .foregroundColor(.white)
                                        HStack(spacing: 0) {
                                            Image(systemName: "mappin")
                                                .foregroundColor(.gray600)
                                            Text("\(currentCourse.course.locationInfo.locality) \(currentCourse.course.locationInfo.subLocality)")
                                                .foregroundColor(.gray600)
                                        }
                                        .font(.customCaption)
                                        .padding(.bottom, 21)
                                    }
                                    .padding(.leading, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .matchedGeometryEffect(id: "\(currentCourse.id)_2", in: namespace)
                                .mask {
                                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 30, style: .circular)
                                }
                                .shadow(color: .white, radius: 0.5, y: -0.5)
                                
                            }
                            .frame(
                                  width: UIScreen.main.bounds.width * 0.4,
                                  height: UIScreen.main.bounds.width * 0.4 * 1.45,
                                  alignment: .trailing
                            )
                           
                            .transition(.opacity)
                            
                            Image("top\(index+1)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.4)
                                .offset(x: -UIScreen.main.bounds.width * 0.22, y: UIScreen.main.bounds.width * 0.18)
                              
                        }
                        .buttonStyle(CardButton())
                        .zIndex(Double(5-index))
                        .frame(
                              width: UIScreen.main.bounds.width * 0.45,
                              height: UIScreen.main.bounds.width * 0.4 * 1.45
                          )
                        .offset(x: 16)
                    }
                   
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(UIScreen.main.bounds.width * 0.05)
        }
        .padding(.top, 36)
    }
}

#Preview {
    HomeTabView()
}
