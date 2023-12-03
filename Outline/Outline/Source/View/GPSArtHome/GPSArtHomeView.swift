//
//  GPSArtHomeView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI

struct GPSArtHomeView: View {
    @AppStorage("authState") var authState: AuthState = .logout
    private let courseScoreModel = CourseScoreModel()
    @StateObject private var viewModel = GPSArtHomeViewModel()
    @StateObject private var appleRunManager = AppleRunManager.shared
    
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollXOffset: CGFloat = 0
    
    @State var currentIndex: Int = 1
    @State private var loading = true
    @State private var selectedCourse: CourseWithDistanceAndScore?
    @State private var showNetworkErrorView = false
    @State private var matched = false
    
    // 받아오는 변수
    @Binding var showDetailView: Bool
    @Namespace private var namespace
    
    let indexWidth: CGFloat = 25
    let indexHeight: CGFloat = 3
    let maxLoadingTime: TimeInterval = 5
    
    var body: some View {
        ZStack {
            if showNetworkErrorView {
                errorView
            } else {
                ScrollView {
                    Color.clear.frame(height: 0)
                        .onScrollViewOffsetChanged { offset in
                            scrollOffset = offset
                        }
                    GPSArtHomeHeader(title: "근처에서\n달려볼까요?", loading: loading, scrollOffset: scrollOffset)
                        .padding(.bottom, -10)
                    
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            getCurrentOffsetView
                            
                            HStack(spacing: 0) {
                                if !viewModel.recommendedCoures.isEmpty {
                                    Button {
                                        withAnimation(.bouncy(duration: 0.7)) {
                                            showDetailView = true
                                            appleRunManager.showAppleRunDetail = true
                                        }
                                    } label: {
                                        AppleRunCard(loading: $loading, showAppleRunDetail: $appleRunManager.showAppleRunDetail, index: 0, currentIndex: currentIndex, namespace: namespace, showDetailView: showDetailView)
                                    }
                                    .buttonStyle(CardButton())
                                    .disabled(loading)
                                    .scrollTransition { content, phase in
                                        content
                                            .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                    }
                                }
                                
                                ForEach(viewModel.recommendedCoures.indices, id: \.self) { index in
                                    Button {
                                        withAnimation(.bouncy(duration: 0.7)) {
                                            selectedCourse = viewModel.recommendedCoures[index]
                                            showDetailView = true
                                            matched = true
                                        }
                                    } label: {
                                        BigCardView(course: viewModel.recommendedCoures[index], loading: $loading, index: index + 1, currentIndex: currentIndex, namespace: namespace, showDetailView: showDetailView)
                                            .scaleEffect(selectedCourse?.id == viewModel.recommendedCoures[index].id ? 0.96 : 1)
                                    }
                                    .buttonStyle(CardButton())
                                    .disabled(loading)
                                    .scrollTransition { content, phase in
                                        content
                                            .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .contentMargins(UIScreen.main.bounds.width * 0.08, for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)
                        .padding(.top, -20)
                        .padding(.bottom, -15)
                        
                        if viewModel.courses.isEmpty {
                            VStack {
                                Rectangle()
                                    .frame(
                                        width: UIScreen.main.bounds.width * 0.84,
                                        height: UIScreen.main.bounds.width * 0.84 * 1.5
                                    )
                                    .roundedCorners(10, corners: [.topLeft])
                                    .roundedCorners(70, corners: [.topRight])
                                    .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
                                    .foregroundColor(.gray700)
                                    .padding(.top, -20)
                                    .padding(.bottom, 13)
                                HStack {
                                    ForEach(0..<4) { _ in
                                        Rectangle()
                                            .frame(width: indexWidth, height: indexHeight)
                                            .foregroundStyle(.gray700)
                                    }
                                }
                                .padding(.bottom, -30)
                            }
                            .padding(.top, 8)
                        }
                        
                        HStack {
                            ForEach(0..<4) { index in
                                Rectangle()
                                    .frame(width: indexWidth, height: indexHeight)
                                    .foregroundStyle(loading ? .gray600 : currentIndex == index ? .customPrimary : .white)
                                    .animation(.bouncy, value: currentIndex)
                            }
                        }
                        .padding(.bottom, -30)
                        
                        MiniScrollView1(selectedCourse: $selectedCourse, courseList: $viewModel.firstCourseList, showDetailView: $showDetailView, category: $viewModel.firstCategoryTitle, namespace: namespace)
                        MiniScrollView2(selectedCourse: $selectedCourse, courseList: $viewModel.secondCourseList, showDetailView: $showDetailView, category: $viewModel.secondCategoryTitle, namespace: namespace)
                        MiniScrollView3(selectedCourse: $selectedCourse, courseList: $viewModel.thirdCourseList, showDetailView: $showDetailView, category: $viewModel.thirdCategoryTitle, namespace: namespace)
                    }
                }
                .overlay(alignment: .top) {
                    GPSArtHomeInlineHeader(loading: loading, scrollOffset: scrollOffset)
                }
                .onAppear {
                    viewModel.checkLocationAuthorization()
                    if viewModel.courses.isEmpty {
                        viewModel.getAllCoursesFromFirebase()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + maxLoadingTime) {
                        if loading {
                            showNetworkErrorView = true
                        }
                    }
                }
                .refreshable {
                    viewModel.getAllCoursesFromFirebase()
                }
            }
            if let selectedCourse, showDetailView {
                Color.gray900.ignoresSafeArea()
                CardDetailView(showDetailView: $showDetailView, selectedCourse: selectedCourse, currentIndex: currentIndex, namespace: namespace)
                    .zIndex(1)
                    .ignoresSafeArea()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(nil),
                            removal: .opacity.animation(.easeInOut.delay(0.1))
                        )
                    )
            }
            
            if showDetailView, appleRunManager.showAppleRunDetail {
                Color.gray900.ignoresSafeArea()
                AppleRunDetail(showDetailView: $showDetailView, showAppleRunDetail: $appleRunManager.showAppleRunDetail, namespace: namespace)
                    .zIndex(1)
                    .ignoresSafeArea()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(nil),
                            removal: .opacity.animation(.easeInOut.delay(0.1))
                        )
                    )
            }
        }
        .background(
            BackgroundBlur(color: Color.customThird, padding: 0)
        )
        .background(
            BackgroundBlur(color: Color.customPrimary, padding: 500)
        )
    }
    
    private var getCurrentOffsetView: some View {
        Color.clear
            .onScrollViewXOffsetChanged { offset in
                scrollXOffset = -offset + UIScreen.main.bounds.width * 0.08
            }
            .onChange(of: scrollXOffset) { _, newValue in
                withAnimation(.bouncy(duration: 1)) {
                    switch newValue {
                    case ..<200:
                        currentIndex = 0
                    case 200..<500:
                        currentIndex = 1
                    case 500..<800:
                        currentIndex = 2
                    case 800...:
                        currentIndex = 3
                    default:
                        break
                    }
                }
            }
    }
}

extension GPSArtHomeView {
    var errorView: some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .foregroundStyle(Color.customPrimary)
                .font(Font.system(size: 40))
            Text("예상치 못한 문제가 발생되었어요.")
                .font(.customDate)
                .foregroundStyle(Color.customWhite)
                .padding(.top, 16)
                .padding(.bottom, 40)
            Button {
                loading = true
                showNetworkErrorView.toggle()
            } label: {
                HStack {
                    Text("다시 시도하기")
                        .font(.customCaption)
                        .foregroundStyle(Color.customPrimary)
                    Image(systemName: "chevron.forward")
                        .font(.customCaption)
                        .foregroundStyle(Color.customPrimary)
                }
            }
        }
    }
}

#Preview {
    HomeTabView()
}
