//
//  BottomScrollView.swift
//  Outline
//
//  Created by 김하은 on 10/16/23.
//

import SwiftUI
import MapKit

struct BottomScrollView: View {
    
    @ObservedObject var vm: HomeTabViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("이런 코스도 있어요.")
                .font(Font.system(size: 20).weight(.semibold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.withoutRecommendedCourses, id: \.id) { currnetCourse in
                        NavigationLink {
                            CourseDetailView(vm: vm, course: currnetCourse)
                        } label: {
                            AsyncImage(url: URL(string: currnetCourse.course.thumbnail))
                                .fixedSize()
                                .frame(width: 164, height: 236)
                                .scaledToFit()
                                .overlay {
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .black, location: 0.00),
                                            Gradient.Stop(color: .black.opacity(0), location: 1.00)
                                        ],
                                        startPoint: UnitPoint(x: 0.5, y: 0.9),
                                        endPoint: UnitPoint(x: 0.5, y: 0)
                                    )
                                    
                                }
                                .overlay {
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Text("\(currnetCourse.course.courseName)")
                                            .font(Font.system(size: 20).weight(.semibold))
                                            .foregroundColor(.white)
                                        HStack(spacing: 0) {
                                            Image(systemName: "mappin")
                                                .foregroundColor(.gray600)
                                            Text("\(currnetCourse.course.locationInfo.locality) \(currnetCourse.course.locationInfo.subLocality)")
                                                .foregroundColor(.gray600)
                                        }
                                        .font(.caption)
                                        .padding(.bottom, 16)
                                    }
                                    .frame(width: 164)
                                    .offset(x: -15)
                                }
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
    
    @ObservedObject var vm: HomeTabViewModel
    var course: CourseWithDistance
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            ScrollView {
                CourseBannerView(vm: vm, course: course)
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("#\(stringForCourseLevel(course.course.level))")
                            .frame(width: 70, height: 23)
                            .background {
                                Capsule()
                                    .stroke()
                            }
                            .foregroundColor(.primaryColor)
                        Text("#\(course.course.courseLength, specifier: "%.0f")km")
                            .frame(width: 70, height: 23)
                            .background {
                                Capsule()
                                    .stroke()
                            }
                        Text("#\(formatDuration(course.course.courseDuration))")
                            .frame(width: 70, height: 23)
                            .background {
                                Capsule()
                                    .stroke()
                            }
                    }
                    .fontWeight(.semibold)
                    .font(.caption)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(course.course.locationInfo.administrativeArea) \(course.course.locationInfo.locality) \(course.course.locationInfo.subLocality)")
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
                            Text("\(course.course.courseLength, specifier: "%.0f")km")
                        }
                        HStack {
                            HStack {
                                Image(systemName: "clock")
                                Text("예상 소요 시간")
                            }
                            .foregroundColor(.primaryColor)
                            Text("\(formatDuration(course.course.courseDuration))")
                        }
                        HStack {
                            HStack {
                                Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                Text("골목길")
                            }
                            .foregroundColor(.primaryColor)
                            Text("\(stringForAlley(course.course.alley))")
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    Text("경로 지도")
                        .font(.title3)
                        .bold()
                    VStack(alignment: .leading) {
                        MapInfoView(
                            camera: MKMapCamera(lookingAtCenter: convertToCLLocationCoordinate(course.course.centerLocation),
                                                fromDistance: 1000, pitch: 0, heading: 0), 
                            coordinates: convertToCLLocationCoordinates(course.course.coursePaths)
                        )
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
    
    @ObservedObject var vm: HomeTabViewModel
    var course: CourseWithDistance
    
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
                Text(course.course.courseName)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("\(course.course.locationInfo.locality) \(course.course.locationInfo.subLocality) • 내 위치에서 \(course.distance/1000, specifier: "%.0f")km")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.bottom, 16)
                
                HStack {
                    Text("\(course.course.courseLength, specifier: "%.0f")km")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                    Text("\(course.course.courseLength, specifier: "%.0f")km")
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
            
            SlideToUnlock(isUnlocked: $vm.start)
                .onChange(of: vm.start) { _, _ in
                    vm.startCourse = course.course
                }
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
