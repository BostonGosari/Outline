//
//  CardDetailView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit

struct CardDetailView: View {
    
    @State private var isUnlocked = false
    @State private var showAlert = false
    @StateObject var runningManager = RunningStartManager.shared
    private let locationManager = CLLocationManager()
    @Environment(\.dismiss) var dismiss
    
    @Binding var showDetailView: Bool
    var selectedCourse: CourseWithDistance
    var currentIndex: Int
    var namespace: Namespace.ID
    
    @State private var appear = [false, false, false]
    @State private var viewSize = 0.0
    @State private var scrollViewOffset: CGFloat = 0
    @State private var dragState: CGSize = .zero
    @State private var isDraggable = true
    @State private var progress: Double = 0.0
    
    private let fadeInOffset: CGFloat = 10
    private let dragStartRange: CGFloat = 60
    private let scrollStartRange: CGFloat = 10
    private let dragLimit: CGFloat = 60
    private let scrollLimit: CGFloat = 40
    
    var body: some View {
        ZStack {
            ScrollView {
                ZStack {
                    Color.gray900
                        .onScrollViewOffsetChanged { value in
                            handleScrollViewOffset(value)
                        }
                    
                    VStack {
                        ZStack {
                            courseImage
                            courseInformation
                        }
                        CardDetailInformationView(selectedCourse: selectedCourse)
                            .opacity(appear[2] ? 1 : 0)
                            .offset(y: appear[2] ? 0 : fadeInOffset)
                    }
                    .mask(
                        RoundedRectangle(cornerRadius: viewSize / 2, style: .continuous)
                    )
                    .scaleEffect(showDetailView ? max(viewSize / -600 + 1, 0.9) : 0.9)
                    .gesture(isDraggable ? drag : nil)
                    
                    slideToUnlock
                        .padding(.top, 485)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .zIndex(1)
                    
                    closeButton
                    
                    Color.black
                        .opacity(progress * 0.8)
                        .animation(.easeInOut, value: progress)
                }
                .onChange(of: showDetailView) { _, _ in
                    fadeOut()
                }
                .onAppear {
                    fadeIn()
                }
            }
            .scrollIndicators(scrollViewOffset > scrollStartRange ? .hidden : .automatic)
            .scrollDisabled(!showDetailView)
            .ignoresSafeArea(edges: .top)
            .statusBarHidden()
            
            ZStack {
                Color.customBlack.opacity(0.7)
                VStack {
                    Spacer()
                    LookAroundModalView {
                        showDetailView = false
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.customPrimary, lineWidth: 2)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(Color.gray900)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
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
                        .foregroundColor(.gray300)
                    Image("AnotherLocation")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                    Button {
                        showAlert = false
                        showDetailView = false
                        runningManager.start = true
                        runningManager.startFreeRun()
                    } label: {
                        Text("자유코스로 변경하기")
                            .font(.button)
                            .foregroundStyle(Color.customBlack)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundStyle(Color.customPrimary)
                            }
                    }
                    .padding()
                    Button {
                        withAnimation {
                            showAlert = false
                            showDetailView = false
                        }
                    } label: {
                        Text("홈으로 돌아가기")
                            .font(.button)
                            .bold()
                            .foregroundStyle(Color.customWhite)
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.customPrimary, lineWidth: 2)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(Color.gray900)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: showAlert ? 0 : UIScreen.main.bounds.height / 2 + 2)
            }
        }
    }
    
    // MARK: - View Components
    
    private var courseImage: some View {
        AsyncImage(url: URL(string: selectedCourse.course.thumbnail)) { image in
            image
                .resizable()
                .roundedCorners(45, corners: [.bottomRight])
                .shadow(color: .white, radius: 0.5, y: 0.5)
        } placeholder: {
            Rectangle()
                .foregroundColor(.gray700)
        }
        .matchedGeometryEffect(id: selectedCourse.id, in: namespace)
        .frame(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height * 0.68
        )
        .transition(.identity)
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(selectedCourse.course.courseName)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("\(selectedCourse.course.locationInfo.locality) \(selectedCourse.course.locationInfo.subLocality) • 내 위치에서 \(selectedCourse.distance/1000, specifier: "%.1f")km")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.bottom, 16)
            }
            .padding(.top, 100)
            .opacity(appear[0] ? 1 : 0)
            .offset(y: appear[0] ? 0 : fadeInOffset)
            
            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var slideToUnlock: some View {
        SlideToUnlock(isUnlocked: $isUnlocked, progress: $progress)
            .onChange(of: isUnlocked) { _, newValue in
                if newValue {
                    let course = selectedCourse.course.coursePaths
                    
                    if runningManager.checkDistance(course: course) {
                        runningManager.startCourse = selectedCourse.course
                        runningManager.startGPSArtRun()
                        showDetailView = false
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
            .opacity(appear[1] ? 1 : 0)
            .offset(y: appear[1] ? 0 : fadeInOffset)
            .padding(-10)
    }
    
    private var closeButton: some View {
        Button {
            withAnimation(.bouncy) {
                showDetailView.toggle()
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(viewSize > 15 ? .clear : .customPrimary)
        }
        .animation(.easeInOut, value: viewSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        .opacity(appear[1] ? 1 : 0)
        .offset(y: appear[1] ? 0 : fadeInOffset)
    }
}

// MARK: - Drag Gesture

extension CardDetailView {
    var drag: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { value in
                if value.translation.width > 0 {
                    if value.startLocation.x < dragStartRange {
                        withAnimation {
                            dragState = value.translation
                            viewSize = dragState.width
                        }
                        if viewSize > dragLimit {
                            withAnimation(.bouncy) {
                                showDetailView = false
                                dragState = .zero
                            }
                        }
                    }
                } else {
                    if value.startLocation.x > UIScreen.main.bounds.width - dragStartRange {
                        withAnimation {
                            dragState = value.translation
                            viewSize = -dragState.width
                        }
                        
                        if viewSize > dragLimit {
                            withAnimation(.bouncy) {
                                showDetailView = false
                                dragState = .zero
                                viewSize = 0.0
                            }
                        }
                    }
                }
            }
            .onEnded { _ in
                if viewSize >= dragLimit {
                    withAnimation(.bouncy) {
                        showDetailView = false
                        viewSize = 0.0
                    }
                } else {
                    withAnimation(.bouncy) {
                        dragState = .zero
                        viewSize = 0.0
                    }
                }
            }
    }
}

// MARK: - View Functions

extension CardDetailView {
    
    private func close() {
        withAnimation(.bouncy.delay(0.3)) {
            showDetailView = false
        }
        
        withAnimation(.bouncy) {
            viewSize = .zero
        }
        
        isDraggable = false
    }
    
    private func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.45)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.6)) {
            appear[2] = true
        }
    }
    
    private func fadeOut() {
        withAnimation(.easeIn(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
        }
    }
    
    private func handleScrollViewOffset(_ value: CGFloat) {
        if dragState.width == 0 {
            scrollViewOffset = value
            
            if scrollViewOffset > scrollStartRange {
                viewSize = scrollViewOffset - scrollStartRange
                
                if scrollViewOffset > scrollLimit {
                    withAnimation(.bouncy) {
                        showDetailView = false
                    }
                }
            } else {
                viewSize = 0
            }
        }
    }
}
