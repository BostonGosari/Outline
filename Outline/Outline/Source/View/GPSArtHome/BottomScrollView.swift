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
    @State private var selectedCourse: CourseWithDistance?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("이런 코스도 있어요.")
                .font(Font.system(size: 20).weight(.semibold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(homeTabViewModel.withoutRecommendedCourses, id: \.id) { currentCourse in
                        VStack {
                            Button {
                                selectedCourse = currentCourse
                            } label: {
                                AsyncImage(url: URL(string: currentCourse.course.thumbnail)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Rectangle()
                                }
                                .frame(width: 164, height: 236)
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
                        .fullScreenCover(item: $selectedCourse) { course in
                            CourseDetailView(homeTabViewModel: homeTabViewModel, course: course)
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
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    var course: CourseWithDistance
    @Environment(\.dismiss) var dismiss
    @StateObject var runningManager = RunningManager.shared
    
    @State private var progress: Double = 0.0
    @State private var isUnlocked = false
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            ZStack {
                ScrollView {
                    ZStack {
                        VStack {
                            CourseBannerView(isUnlocked: $isUnlocked, showAlert: $showAlert, progress: $progress, homeTabViewModel: homeTabViewModel, course: course)
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
                                    MapInfoView(coordinates: convertToCLLocationCoordinates(course.course.coursePaths))
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
                        closeButton
                        Color.black.opacity(progress * 0.8)
                            .animation(.easeInOut, value: progress)
                    }
                }
                ZStack {
                    if showAlert {
                        Color.black.opacity(0.5)
                            .onTapGesture {
                                withAnimation {
                                    showAlert = false
                                    progress = 0.0
                                }
                            }
                    }
                    VStack(spacing: 10) {
                        Text("자유코스로 변경할까요?")
                            .font(.title2)
                        Text("앗! 현재 루트와 멀리 떨어져 있어요.")
                            .font(.subBody)
                            .foregroundColor(.gray300Color)
                        Image("AnotherLocation")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                        Button {
                            showAlert = false
                            dismiss()
                            runningManager.start = true
                            runningManager.startFreeRun()
                        } label: {
                            Text("자유코스로 변경하기")
                                .font(.button)
                                .foregroundStyle(Color.blackColor)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .foregroundStyle(Color.primaryColor)
                                }
                        }
                        .padding()
                        Button {
                            withAnimation {
                                showAlert = false
                                dismiss()
                            }
                        } label: {
                            Text("홈으로 돌아가기")
                                .font(.button)
                                .bold()
                                .foregroundStyle(Color.whiteColor)
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Color.primaryColor, lineWidth: 2)
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .foregroundStyle(Color.gray900Color)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: showAlert ? 0 : UIScreen.main.bounds.height / 2 + 2)
                }
            }
            .ignoresSafeArea()
        }
        .statusBarHidden()
    }
    
    private var closeButton: some View {
        Button {
            withAnimation(.closeCard) {
                dismiss()
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.primaryColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
    }
}

struct CourseBannerView: View {
    
    @Binding var isUnlocked: Bool
    @Binding var showAlert: Bool
    @Binding var progress: Double

    private let locationManager = CLLocationManager()
    @StateObject var runningManager = RunningManager.shared
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    @Environment(\.dismiss) var dismiss
    var course: CourseWithDistance
    
    var body: some View {
        ZStack {
            courseImage
            courseInformation
        }
    }
    
    private var courseImage: some View {
        AsyncImage(url: URL(string: course.course.thumbnail)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle()
                .scaledToFit()
        }
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
            }
            .padding(.top, 100)
            
            Spacer()
            
            SlideToUnlock(isUnlocked: $isUnlocked, progress: $progress)
                .onChange(of: isUnlocked) { _, newValue in
                    if newValue {
                        let userLocation = locationManager.location?.coordinate
                        let coursePaths = course.course.coursePaths
                        if let userLocation = userLocation, runningManager.checkDistance(userLocation: userLocation, course: coursePaths) {
                            runningManager.startCourse = course.course
                            runningManager.startGPSArtRun()
                            runningManager.start = true
                            isUnlocked = false
                        } else {
                            isUnlocked = false
                            withAnimation {
                                showAlert = true
                            }
                        }
                    }
                }
                .padding(-10)
        }
        .padding(40)
    }
}

#Preview {
    HomeTabView()
}
