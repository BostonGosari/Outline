//
//  BottomScrollView.swift
//  Outline
//
//  Created by 김하은 on 10/16/23.
//

import SwiftUI

struct BottomScrollView: View {
    
    @ObservedObject var viewModel: GPSArtHomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("이런 코스도 있어요.")
                .font(Font.system(size: 20).weight(.semibold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.withoutRecommendedCourses, id: \.id) { course in
                        NavigationLink {
                            CourseDetailView()
                        } label: {
                            Rectangle()
                                .frame(width: 164, height: 236)
                                .background(
                                    ZStack {
                                        Image("Sample")
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: .black, location: 0.00),
                                                Gradient.Stop(color: .black.opacity(0), location: 1.00)
                                            ],
                                            startPoint: UnitPoint(x: 0.5, y: 0.9),
                                            endPoint: UnitPoint(x: 0.5, y: 0)
                                        )
                                        VStack(alignment: .leading) {
                                            Spacer()
                                            Text("\(course.course.courseName)")
                                                .font(Font.system(size: 20).weight(.semibold))
                                                .foregroundColor(.white)
                                            HStack(spacing: 0) {
                                                Image(systemName: "mappin")
                                                    .foregroundColor(.gray600)
                                                Text("서울시 동작구")
                                                    .foregroundColor(.gray600)
                                            }
                                            .font(.caption)
                                            .padding(.bottom, 16)
                                        }
                                        .frame(width: 164)
                                        .offset(x: -15)
                                    }
                                    
                                )
                                .roundedCorners(5, corners: [.topLeft])
                                .roundedCorners(30, corners: [.bottomLeft, .bottomRight, .topRight])
                                .foregroundColor(.clear)
                                .overlay(
                                    CustomRoundedRectangle(
                                        cornerRadiusTopLeft: 5,
                                        cornerRadiusTopRight: 29,
                                        cornerRadiusBottomLeft: 29,
                                        cornerRadiusBottomRight: 29
                                    )
                                    .offset(x: 1, y: 1)
                                    .frame(width: 166, height: 238)
                                )
                        }
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 106)
        }
        .padding(.top, 33)
        .safeAreaInset(edge: .leading) {
            Color.clear
                .frame(width: 16)
        }
        .safeAreaInset(edge: .trailing) {
            Color.clear
                .frame(width: 16)
        }
    }
}

struct CourseDetailView: View {
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            ScrollView {
                CourseBannerView()
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("#어려움")
                            .frame(width: 70, height: 23)
                            .background {
                                Capsule()
                                    .stroke()
                            }
                            .foregroundColor(.primaryColor)
                        Text("#5km")
                            .frame(width: 70, height: 23)
                            .background {
                                Capsule()
                                    .stroke()
                            }
                        Text("#2h39m")
                            .frame(width: 70, height: 23)
                            .background {
                                Capsule()
                                    .stroke()
                            }
                    }
                    .fontWeight(.semibold)
                    .font(.caption)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("경상북도 포항시 남구 효자로")
                            .font(.title3)
                            .bold()
                        Text("포항의 야경을 바라보며 뛸 수 있는 러닝코스")
                            .foregroundStyle(.gray)
                    }
                    
                    Divider()
                    
                    Text("경로 정보")
                        .font(.title3)
                        .bold()
                    VStack(alignment: .leading, spacing: 17) {
                        HStack {
                            HStack {
                                Image(systemName: "flag")
                                Text("추천 시작 위치")
                            }
                            .foregroundColor(.primaryColor)
                            Text("포항시 남구 효자로")
                        }
                        HStack {
                            HStack {
                                Image(systemName: "location")
                                Text("거리")
                            }
                            .foregroundColor(.primaryColor)
                            Text("9km")
                        }
                        HStack {
                            HStack {
                                Image(systemName: "clock")
                                Text("예상 소요 시간")
                            }
                            .foregroundColor(.primaryColor)
                            Text("2h 39m")
                        }
                        HStack {
                            HStack {
                                Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                Text("골목길")
                            }
                            .foregroundColor(.primaryColor)
                            Text("많음")
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    Text("경로 지도")
                        .font(.title3)
                        .bold()
                    VStack(alignment: .leading) {
                        Rectangle()
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
            .ignoresSafeArea()
        }
    }
}

struct CourseBannerView: View {
    var body: some View {
            ZStack {
                courseImage
                courseInformation
            }
    }
    
    private var courseImage: some View {
        Rectangle()
            .foregroundColor(.gray800)
            .roundedCorners(45, corners: [.bottomLeft])
            .shadow(color: .white, radius: 0.5, y: 0.5)
            .frame(height: 575)
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("시티런")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("서울시 동작구 • 내 위치에서 5km")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.bottom, 16)
                
                HStack {
                    Text("#5km")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                    Text("#2h39m")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                }
                .font(.caption)
            }
            .padding(.top, 100)
            
            Spacer()
            
            SlideToUnlock()
                .padding(-10)
        }
        .padding(40)
    }
}

struct BottomScrollDetailView: View {
    var body: some View {
        Text("1")
    }
}
//
//#Preview {
//    BottomScrollView()
//}
