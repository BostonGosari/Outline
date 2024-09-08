//
//  MirroringView.swift
//  Outline
//
//  Created by hyunjun on 11/22/23.
//

import SwiftUI

struct MirroringView: View {
    @StateObject private var connectivityManager = ConnectivityManager.shared
    @StateObject private var runningManager = RunningStartManager.shared
    
    @AppStorage("isFirstRunning") private var isFirstRunning = true
    
    @GestureState private var press = false
    
    @State private var showDetail = false
    @State private var isPaused = false
    @State private var showCompleteSheet = false
    @State private var tapGuideView = false
    
    @State private var navigationTranslation: CGFloat = 0.0
    @State private var navigationSheetHeight: CGFloat = 0.0
    @State private var metricsTranslation: CGFloat = 0.0
    @State private var metricsSheetHeight: CGFloat = 0.0
    @State private var stopButtonScale: CGFloat = 1
    @State private var showStopPopup = false {
        didSet {
            if showStopPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.showStopPopup = false
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            map
            metrics
            
            if connectivityManager.runningInfo.runningType == .gpsArt {
                guideView
            }
        }
        .overlay {
            if isFirstRunning && connectivityManager.runningInfo.runningType == .gpsArt {
                FirstRunningGuideView(isFirstRunning: $isFirstRunning)
            }
        }
        .overlay {
            if showStopPopup {
                RunningPopup(text: "정지 버튼을 길게 누르면 러닝이 종료돼요")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onChange(of: tapGuideView) {
            withAnimation {
                showDetail = false
            }
        }
        .onDisappear {
            connectivityManager.runningData.time = 0
        }
        .onChange(of: connectivityManager.runningState) { _, newValue in
            if newValue == .pause {
                withAnimation {
                    showDetail = true
                    isPaused = true
                    if navigationSheetHeight != 0 {
                        navigationSheetHeight = 0
                    }
                }
            } else {
                withAnimation {
                    showDetail = false
                    isPaused = false
                    if navigationSheetHeight != 0 {
                        navigationSheetHeight = 0
                    }
                }
            }
        }
    }
}

extension MirroringView {
    private var map: some View {
        MirroringMapView()
            .ignoresSafeArea()
    }
    
    private var navigation: some View {
        RunningNavigationView(
            courseName: runningManager.startCourse?.courseName ?? "",
            showDetailNavigation: navigationTranslation + navigationSheetHeight > 10
        )
            .frame(height: 70 + navigationTranslation + navigationSheetHeight, alignment: .top)
            .mask {
                UnevenRoundedRectangle(bottomTrailingRadius: 50)
            }
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 6, opaque: true)
                    .ignoresSafeArea()
                    .overlay {
                        UnevenRoundedRectangle(bottomTrailingRadius: 50)
                            .foregroundStyle(.black50)
                            .ignoresSafeArea()
                            .overlay(alignment: .bottom) {
                                Capsule()
                                    .frame(width: 40, height: 3)
                                    .padding(.bottom, 9)
                                    .foregroundStyle(.gray600)
                            }
                        
                    }
            }
            .zIndex(1)
            .gesture(navigationGesture)
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private var metrics: some View {
        MirroringMetricsView(showDetail: showDetail, isPaused: isPaused)
            .overlay(alignment: .topTrailing) {
                showDetailButton
            }
            .padding(.top, 26)
            .frame(height: showDetail ? 360 + metricsTranslation : 80, alignment: .top)
            .mask {
                RoundedRectangle(cornerRadius: 20)
            }
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 6, opaque: true)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.black50)
                            .ignoresSafeArea()
                    }
                    .ignoresSafeArea()
            }
            .gesture(metricsGesture)
            .overlay(alignment: .bottom) {
                controlButton
            }
            .zIndex(1)
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private var showDetailButton: some View {
        Button {
            withAnimation {
                showDetail.toggle()
                navigationSheetHeight = 0
                navigationTranslation = 0.0
            }
        } label: {
            Image(systemName: "chevron.up.circle.fill")
                .rotationEffect(showDetail ? .degrees(-180) : .degrees(0))
                .font(.system(size: 35))
                .padding(.trailing, 16)
                .foregroundStyle(.gray600, .gray700)
                .fontWeight(.semibold)
        }
    }
    
    private var controlButton: some View {
        ZStack {
            Image(systemName: "stop.circle.fill")
                .font(.system(size: 60))
                .fontWeight(.ultraLight)
                .foregroundStyle(.black, .customWhite)
                .gesture(stopButtonGesture)
                .scaleEffect(press ? 1.5 : 1)
                .animation(.easeInOut, value: press)
                .frame(maxWidth: .infinity, alignment: isPaused ? .leading : .center)
            
            Button {
                withAnimation {
                    showDetail = false
                    isPaused = false
                    if navigationSheetHeight != 0 {
                        navigationSheetHeight = 0
                    }
                }
                
                connectivityManager.sendRunningState(.resume)
            } label: {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 60))
                    .background {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.customPrimary)
                    }
                    .foregroundStyle(.black, .customPrimary)
            }
            .frame(maxWidth: .infinity, alignment: isPaused ? .trailing : .center)
            
            Button {
                withAnimation {
                    showDetail = true
                    isPaused = true
                    if navigationSheetHeight != 0 {
                        navigationSheetHeight = 0
                    }
                }
                connectivityManager.sendRunningState(.pause)
            } label: {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 60))
                    .background {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.customPrimary)
                    }
                    .foregroundStyle(.black, .customPrimary)
            }
            .buttonStyle(.plain)
            .opacity(isPaused ? 0 : 1)
            .animation(nil, value: isPaused)
            .zIndex(1)
        }
        .padding(.horizontal, 90)
    }
    
    private var guideView: some View {
        ZStack {
            let userLocations = connectivityManager.runningData.userLocations.toCLLocationCoordinates()
            let course = connectivityManager.runningInfo.course.toCLLocationCoordinates()
            
            CourseGuideView(
                tapGuideView: $tapGuideView,
                coursePathCoordinates: course,
                courseRotate: 0.0,
                userLocations: userLocations,
                tapPossible: !(navigationTranslation + navigationSheetHeight > 10)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: tapGuideView ? .top : .topTrailing)
            .padding(.top, 20)
            .padding(.trailing, tapGuideView ? 0 : 16)
        }
        .zIndex(tapGuideView ? 2 : 0)
        .background {
            if tapGuideView {
                Color.black50.ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            tapGuideView = false
                        }
                    }
            }
        }
    }
}

extension MirroringView {
    private var navigationGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation {
                    showDetail = false
                }
                let translationY = value.translation.height
                if navigationSheetHeight == 0 {
                    navigationTranslation = min(max(translationY, -5), 340)
                } else {
                    navigationTranslation = max(min(translationY, 40), -310)
                }
            }
            .onEnded { value in
                withAnimation {
                    showDetail = false
                }
                let translationY = value.translation.height
                withAnimation(.bouncy) {
                    if translationY > 0 {
                        navigationSheetHeight = 300
                    } else {
                        navigationSheetHeight = 0
                    }
                    navigationTranslation = 0.0
                }
            }
            .simultaneously(with: TapGesture()
                .onEnded { _ in
                    withAnimation {
                        showDetail = false
                    }
                    withAnimation {
                        if navigationSheetHeight == 0 {
                            navigationSheetHeight = 300
                        } else {
                            navigationSheetHeight = 0
                        }
                    }
                }
            )
    }
    
    private var metricsGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if !isPaused {
                    let translationY = value.translation.height
                    if showDetail {
                        withAnimation {
                            metricsTranslation = min(-translationY, 30)
                            navigationTranslation = 0
                        }
                    }
                }
            }
            .onEnded { value in
                if !isPaused {
                    let translationY = value.translation.height
                    if showDetail {
                        withAnimation(.bouncy) {
                            if translationY > 0 {
                                showDetail = false
                            }
                            metricsTranslation = 0.0
                            navigationTranslation = 0
                        }
                    }
                }
            }
    }
    
    private var stopButtonGesture: some Gesture {
        LongPressGesture(minimumDuration: 1.5)
            .updating($press) { (currentState, gestureState, _) in
                gestureState = currentState
            }
            .onEnded { _ in
                connectivityManager.sendRunningState(.end)
                runningManager.mirroring = false
            }
            .simultaneously(with: TapGesture()
                .onEnded { _ in
                    withAnimation {
                        stopButtonScale = 1
                        showStopPopup = true
                    }
                }
            )
    }
}

#Preview {
    MirroringView()
}
