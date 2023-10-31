//
//  GPSArtHomeView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI

struct GPSArtHomeView: View {
    @StateObject private var viewModel = GPSArtHomeViewModel()
    
    @State private var scrollOffset: CGFloat = 0
    @State private var scrollXOffset: CGFloat = 0
    
    @State var currentIndex: Int = 0
    @State private var loading = true
    @State private var selectedCourse: CourseWithDistance?
    
    // 받아오는 변수
    @Binding var showDetailView: Bool
    @Namespace private var namespace
    
    let indexWidth: CGFloat = 25
    let indexHeight: CGFloat = 3
    
    var body: some View {
        ZStack {
            ScrollView {
                Color.clear.frame(height: 0)
                    .onScrollViewOffsetChanged { offset in
                        scrollOffset = offset
                    }
                Header(loading: loading, scrollOffset: scrollOffset)
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        getCurrentOffsetView
                        
                        HStack(spacing: 0) {
                            ForEach(viewModel.recommendedCoures.indices, id: \.self) { index in
                                Button {
                                    withAnimation(.openCard) {
                                        selectedCourse = viewModel.recommendedCoures[index]
                                        showDetailView = true
                                    }
                                } label: {
                                    BigCardView(course: viewModel.recommendedCoures[index], loading: $loading, index: index, currentIndex: currentIndex, namespace: namespace, showDetailView: showDetailView)
                                        .scaleEffect(selectedCourse?.id == viewModel.recommendedCoures[index].course.id ? 0.96 : 1)
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
                    .padding(.vertical, -20)
                    
                    if viewModel.courses.isEmpty {
                        Rectangle()
                            .frame(
                                width: UIScreen.main.bounds.width * 0.84,
                                height: UIScreen.main.bounds.height * 0.55
                            )
                            .foregroundColor(.gray700)
                            .padding(.vertical, -20)
                    }
                    
                    HStack {
                        ForEach(0..<3) { index in
                            Rectangle()
                                .frame(width: indexWidth, height: indexHeight)
                                .foregroundColor(loading ? .gray700 : currentIndex == index ? .customPrimary : .white)
                                .animation(.bouncy, value: currentIndex)
                        }
                    }
                    
                    BottomScrollView(viewModel: viewModel, selectedCourse: $selectedCourse, showDetailView: $showDetailView, namespace: namespace)
                }
            }
            .overlay(alignment: .top) {
                InlineHeader(loading: loading, scrollOffset: scrollOffset)
            }
            .onAppear {
                viewModel.getAllCoursesFromFirebase()
            }
            .refreshable {
                viewModel.fetchRecommendedCourses()
            }
            
            if let selectedCourse, showDetailView {
                Color.gray900.ignoresSafeArea()
                CardDetailView(showDetailView: $showDetailView, selectedCourse: selectedCourse, currentIndex: currentIndex, namespace: namespace)
                    .zIndex(1)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                            removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                        )
                    )
                    .ignoresSafeArea()
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
                    case 500...:
                        currentIndex = 2
                    default:
                        break
                    }
                }
            }
    }
}

#Preview {
    HomeTabView()
}
