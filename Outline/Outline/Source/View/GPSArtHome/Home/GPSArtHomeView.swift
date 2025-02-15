//
//  GPSArtHomeView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI

struct GPSArtHomeView: View {
    @Binding var showDetailView: Bool
    @StateObject private var viewModel = GPSArtHomeViewModel()

    @Namespace private var namespace

    private let indicatorWidth: CGFloat = 25
    private let indicatorHeight: CGFloat = 3

    var body: some View {
        ZStack {
            if viewModel.showNetworkErrorView {
                 errorView
             } else {
                 ScrollView {
                    Color.clear.frame(height: 0)
                        .onScrollViewOffsetChanged { offset in
                            viewModel.scrollOffset = offset
                        }
                     Header(title: "근처에서\n달려볼까요?", loading: viewModel.loading, scrollOffset: viewModel.scrollOffset)
                         .padding(.bottom, -10)
                    
                    VStack(spacing: 0) {
                        bigCardCourses

                        if viewModel.courses.isEmpty {
                            emptyCoursePlaceHolder
                        }
                        
                        bigCardIndexIndicator

                        CategoryScrollView(
                            selectedCourse: $viewModel.selectedCourse,
                            courseList: $viewModel.firstCourseList,
                            showDetailView: $showDetailView,
                            category: $viewModel.firstCategoryTitle,
                            namespace: namespace
                        )
                        RankingScrollView(
                            selectedCourse: $viewModel.selectedCourse,
                            courseList: $viewModel.secondCourseList,
                            showDetailView: $showDetailView,
                            category: $viewModel.secondCategoryTitle,
                            namespace: namespace
                        )
                        CategoryScrollView(
                            selectedCourse: $viewModel.selectedCourse,
                            courseList: $viewModel.thirdCourseList,
                            showDetailView: $showDetailView,
                            category: $viewModel.thirdCategoryTitle, namespace: namespace
                        )
                        .padding(.bottom, 120)
                    }
                }
                .overlay(alignment: .top) {
                    InlineHeader(loading: viewModel.loading, scrollOffset: viewModel.scrollOffset)
                }
                .onAppear {
                    viewModel.onAppear()
                }
                .refreshable {
                    viewModel.getAllCoursesFromFirebase()
                }
            }
            if let selectedCourse = viewModel.selectedCourse, showDetailView {
                Color.gray900.ignoresSafeArea()
                CardDetailView(showDetailView: $showDetailView, selectedCourse: selectedCourse, currentIndex: viewModel.currentIndex, namespace: namespace)
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
    }
}

private extension GPSArtHomeView {
    var getCurrentOffsetView: some View {
        Color.clear
            .onScrollViewXOffsetChanged { offset in
                viewModel.scrollXOffset = -offset + UIScreen.main.bounds.width * 0.08
            }
            .onChange(of: viewModel.scrollXOffset) { _, newValue in
                withAnimation(.bouncy(duration: 1)) {
                    switch newValue {
                    case ..<200:
                        viewModel.currentIndex = 0
                    case 200..<500:
                        viewModel.currentIndex = 1
                    case 500...:
                        viewModel.currentIndex = 2
                    default:
                        break
                    }
                }
            }
    }

    var bigCardCourses: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            getCurrentOffsetView

            HStack(spacing: 0) {
                ForEach(viewModel.recommendedCoures.indices, id: \.self) { index in
                    Button {
                        withAnimation(.bouncy(duration: 0.7)) {
                            viewModel.selectedCourse = viewModel.recommendedCoures[index]
                            showDetailView = true
                            viewModel.matched = true
                        }
                    } label: {
                        BigCardView(loading: $viewModel.loading, course: viewModel.recommendedCoures[index],  index: index, currentIndex: viewModel.currentIndex, namespace: namespace, showDetailView: showDetailView)
                            .scaleEffect(viewModel.selectedCourse?.id == viewModel.recommendedCoures[index].id ? 0.96 : 1)
                    }
                    .buttonStyle(CardButton())
                    .disabled(viewModel.loading)
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
    }

    var emptyCoursePlaceHolder: some View {
        VStack {
            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                .frame(
                    width: UIScreen.main.bounds.width * 0.84,
                    height: UIScreen.main.bounds.width * 0.84 * 1.5
                )
                .foregroundColor(.gray700)
                .padding(.top, -20)
                .padding(.bottom, 13)
            HStack {
                ForEach(0..<3) { _ in
                    Rectangle()
                        .frame(width: indicatorWidth, height: indicatorHeight)
                        .foregroundStyle(.gray700)
                }
            }
            .padding(.bottom, -30)
        }
        .padding(.top, 8)
    }

    var bigCardIndexIndicator: some View {
        HStack {
            ForEach(0..<3) { index in
                Rectangle()
                    .frame(width: indicatorWidth, height: indicatorHeight)
                    .foregroundStyle(viewModel.loading ? .gray600 : viewModel.currentIndex == index ? .customPrimary : .white)
                    .animation(.bouncy, value: viewModel.currentIndex)
            }
        }
        .padding(.bottom, -30)
    }

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
                viewModel.loading = true
                viewModel.showNetworkErrorView.toggle()
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
