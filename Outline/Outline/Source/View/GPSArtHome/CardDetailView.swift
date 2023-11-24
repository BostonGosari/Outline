//
//  CardDetailView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit
import Kingfisher

struct CardDetailView: View {
    @AppStorage("authState") var authState: AuthState = .logout
    
    @State private var isUnlocked = false
    @State private var showAlert = false
    @State private var showNeedLoginSheet = false
    @StateObject var runningStartManager = RunningStartManager.shared
    private let locationManager = CLLocationManager()
    @Environment(\.dismiss) var dismiss
    
    @Binding var showDetailView: Bool
    var selectedCourse: CourseWithDistanceAndScore
    var currentIndex: Int
    var namespace: Namespace.ID
    
    @State private var appear = [false, false, false]
    @State private var viewSize = 0.0
    @State private var scrollViewOffset: CGFloat = 0
    @State private var dragState: CGSize = .zero
    @State private var isDraggable = true
    @State private var progress: Double = 0.0
    @State private var showCopyLocationPopup = false
    
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
                        ZStack(alignment: .top) {
                            if showDetailView {
                                courseImage
                                courseInformation
                            } else {
                                UnevenRoundedRectangle(bottomTrailingRadius: 45, style: .circular)
                                    .frame(
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height * 0.68
                                    )
                                    .foregroundStyle(.clear)
                            }
                        }
                        CardDetailInformationView(
                            showCopyLocationPopup: $showCopyLocationPopup, selectedCourse: selectedCourse.course
                        )
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
        }
        .overlay {
            if showCopyLocationPopup {
                RunningPopup(text: "시작 위치 도로명이 복사되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 52)
            } else {
                EmptyView()
            }
        }
        .sheet(isPresented: $showAlert) {
            progress = 0.0
        } content: {
            GuideToFreeRunningSheet {
                showDetailView = false
                runningStartManager.start = true
                runningStartManager.startFreeRun()
            }
        }
        .sheet(isPresented: $showNeedLoginSheet) {
            NeedLoginSheet(type: .running) {
                showDetailView = false
            }
        }
        .onAppear {
            if authState == .lookAround {
                showNeedLoginSheet = true
            }
        }
    }
    
    // MARK: - View Components
    
    private var courseImage: some View {
        KFImage(URL(string: selectedCourse.course.thumbnail))
            .resizable()
            .placeholder {
                Rectangle()
                    .foregroundColor(.clear)
            }
            .mask {
                UnevenRoundedRectangle(bottomTrailingRadius: 45, style: .circular)
            }
            .overlay {
                    UnevenRoundedRectangle(bottomTrailingRadius: 45, style: .circular)
                    .stroke(Color.gray, lineWidth: 1)
            }
            .matchedGeometryEffect(id: selectedCourse.id, in: namespace)
            .frame(
                width: UIScreen.main.bounds.width + 2,
                height: UIScreen.main.bounds.height * 0.68
            )
            .offset(y: -1)
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(selectedCourse.course.courseName)")
                    .font(.customHeadline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("\(selectedCourse.course.locationInfo.locality) \(selectedCourse.course.locationInfo.subLocality) • 내 위치에서 \(selectedCourse.distance/1000, specifier: "%.1f")km")
                }
                .font(.customSubbody)
                .fontWeight(.regular)
                .foregroundStyle(.gray400)
                .padding(.bottom, 16)
            }
            .padding(.top, 60)
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
                    runningStartManager.checkAuthorization()
                    if runningStartManager.isHealthAuthorized {
                        if runningStartManager.isLocationAuthorized {
                            let course = selectedCourse.course.coursePaths
                            
                            if runningStartManager.checkDistance(course: course) {
                                runningStartManager.startCourse = selectedCourse.course
                                runningStartManager.startGPSArtRun()
                                showDetailView = false
                                runningStartManager.start = true
                                isUnlocked = false
                            } else {
                                isUnlocked = false
                                withAnimation {
                                    showAlert = true
                                }
                            }
                        } else {
                            runningStartManager.showPermissionSheet = true
                            runningStartManager.permissionType = .location
                            isUnlocked = false
                        }
                    } else {
                        runningStartManager.showPermissionSheet = true
                        runningStartManager.permissionType = .health
                        isUnlocked = false
                    }
                }
            }
            .opacity(appear[1] ? 1 : 0)
            .offset(y: appear[1] ? 0 : fadeInOffset)
            .padding(-10)
    }
    
    private var closeButton: some View {
        Button {
            withAnimation {
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
                            withAnimation {
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
                            withAnimation {
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
                    withAnimation {
                        showDetailView = false
                        viewSize = 0.0
                    }
                } else {
                    withAnimation {
                        dragState = .zero
                        viewSize = 0.0
                    }
                }
            }
    }
}

// MARK: - View Functions

extension CardDetailView {
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
                    withAnimation {
                        showDetailView = false
                    }
                }
            } else {
                viewSize = 0
            }
        }
    }
}
