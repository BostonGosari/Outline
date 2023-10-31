//
//  BottomScrollView.swift
//  Outline
//
//  Created by 김하은 on 10/16/23.
//

import SwiftUI
import MapKit

struct BottomScrollView: View {
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    @Binding var selectedCourse: CourseWithDistance?
    @Binding var showDetailView: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("이런 코스도 있어요.")
                .padding(.leading, 16)
                .font(.subtitle)
                .foregroundColor(.white)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(homeTabViewModel.withoutRecommendedCourses, id: \.id) { currentCourse in
                        ZStack {
                            Button {
                                withAnimation(.openCard) {
                                    selectedCourse = currentCourse
                                    showDetailView = true
                                }
                            } label: {
                                ZStack {
                                    AsyncImage(url: URL(string: currentCourse.course.thumbnail)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Rectangle()
                                            .foregroundColor(.gray700Color)
                                    }
                                    .matchedGeometryEffect(id: currentCourse.id, in: namespace)
                                    .overlay {
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: .black, location: 0.00),
                                                Gradient.Stop(color: .black.opacity(0), location: 1.00)
                                            ],
                                            startPoint: UnitPoint(x: 0.5, y: 0.9),
                                            endPoint: UnitPoint(x: 0.5, y: 0.1)
                                        )
                                        
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
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
                                        .font(.caption)
                                        .padding(.bottom, 21)
                                    }
                                    .padding(.leading, 20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(
                                    width: UIScreen.main.bounds.width * 0.4,
                                    height: UIScreen.main.bounds.height * 0.25
                                )
                                .roundedCorners(5, corners: [.topLeft])
                                .roundedCorners(30, corners: [.topRight, .bottomLeft, .bottomRight])
                                .frame(
                                    width: UIScreen.main.bounds.width * 0.4,
                                    height: UIScreen.main.bounds.height * 0.25 + 1
                                )
                                .shadow(color: .white, radius: 0.5, x: 0, y: -0.5)
                                .shadow(color: .white, radius: 0.5, x: 0.5, y: 0)
                                .shadow(color: .white, radius: 0.5, x: 0, y: 0.5)
                                .shadow(color: .white, radius: 0.5, x: -0.5, y: 0)
                            }
                            .buttonStyle(CardButton())
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(UIScreen.main.bounds.width * 0.05)
        }
        .padding(.top, 30)
        .padding(.bottom, 70)
    }
}

#Preview {
    HomeTabView()
}
