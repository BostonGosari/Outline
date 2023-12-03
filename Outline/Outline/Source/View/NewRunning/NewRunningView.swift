//
//  NewRunningView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import SwiftUI
import CoreMotion

struct NewRunningView: View {
    @StateObject private var connectivityManger = WatchConnectivityManager.shared
    @StateObject private var runningStartManager = RunningStartManager.shared
    @StateObject private var runningDataManager = RunningDataManager.shared
    @StateObject private var locationManager = LocationManager.shared
    
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
            if let startCourse = runningStartManager.startCourse,
                !startCourse.navigation.isEmpty {
                navigation
            }
            metrics
            guideView
            
            RunningFinishPopUp(isPresented: $showCompleteSheet, score: $runningDataManager.score, userLocations: $locationManager.userLocations)
        }
        .onAppear {
            locationManager.userLocations = []
        }
        .overlay {
            if isFirstRunning && runningStartManager.runningType == .gpsArt {
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
            runningStartManager.counter = 0
        }
        .onChange(of: runningStartManager.counter) { _, newValue in
            if connectivityManger.isMirroring {
                let userLocations = ConvertCoordinateManager.convertToCoordinates(locationManager.userLocations)
                
                let runningData = MirroringRunningData(
                    userLocations: userLocations,
                    time: Double(newValue),
                    distance: runningDataManager.distance,
                    kcal: runningDataManager.kilocalorie,
                    pace: runningDataManager.pace,
                    bpm: 0
                )
                
                connectivityManger.sendRunningData(runningData)
            }
        }
        .onChange(of: connectivityManger.runningState) { _, newValue in
            if newValue == .pause {
                withAnimation {
                    showDetail = true
                    isPaused = true
                    if navigationSheetHeight != 0 {
                        navigationSheetHeight = 0
                    }
                }
                runningDataManager.pauseRunning()
                runningStartManager.stopTimer()
                locationManager.isRunning = false
            } else if newValue == .resume {
                withAnimation {
                    showDetail = false
                    isPaused = false
                    if navigationSheetHeight != 0 {
                        navigationSheetHeight = 0
                    }
                }
                runningDataManager.resumeRunning()
                runningStartManager.startTimer()
                locationManager.isRunning = true
            } else if newValue == .end {
                DispatchQueue.main.async {
                    if runningStartManager.counter < 30 {
                        runningDataManager.stopRunningWithoutRecord()
                        runningStartManager.stopTimer()
                        runningStartManager.running = false
                        locationManager.isRunning = false
                        if connectivityManger.isMirroring {
                            connectivityManger.sendRunningState(.end)
                        }
                    } else {
                        runningDataManager.userLocations = locationManager.userLocations
                        runningStartManager.stopTimer()
                        locationManager.isRunning = false
                        withAnimation {
                            showCompleteSheet = true
                        }
                        runningDataManager.stopRunning()
                        if connectivityManger.isMirroring {
                            connectivityManger.sendRunningState(.end)
                        }
                    }
                }
            }
        }
    }
}

extension NewRunningView {
    private var map: some View {
        NewRunningMapView(userLocations: locationManager.userLocations)
            .onAppear {
                if runningStartManager.running == true {
                    runningDataManager.startRunning()
                    runningStartManager.startTimer()
                    Task {
                        await runningDataManager.startLiveActivity()
                    }
                }
            }
    }
    
    private var navigation: some View {
        NewRunningNavigationView(
            courseName: runningStartManager.startCourse?.courseName ?? "",
            showDetailNavigation: navigationTranslation + navigationSheetHeight > 10
        )
            .frame(height: 70 + navigationTranslation + navigationSheetHeight, alignment: .top)
            .mask {
                Rectangle()
                    .roundedCorners(50, corners: .bottomRight)
            }
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 6, opaque: true)
                    .ignoresSafeArea()
                    .overlay {
                        Rectangle()
                            .roundedCorners(50, corners: .bottomRight)
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
            .onAppear {
                locationManager.navigationDatas = runningStartManager.startCourse?.navigation
                locationManager.initNavigation()
            }
    }
    
    private var metrics: some View {
        NewRunningMetricsView(showDetail: showDetail, isPaused: isPaused)
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
                    .ignoresSafeArea()
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.black50)
                            .ignoresSafeArea()
                    }
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
            Button {
            } label: {
                Image(systemName: "stop.circle.fill")
                    .font(.system(size: 60))
                    .fontWeight(.ultraLight)
                    .foregroundStyle(.black, .customWhite)
                    .gesture(stopButtonGesture)
                    .scaleEffect(press ? 1.5 : 1)
            }
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
                runningDataManager.resumeRunning()
                runningStartManager.startTimer()
                if connectivityManger.isMirroring {
                    connectivityManger.sendRunningState(.resume)
                }
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
                runningDataManager.pauseRunning()
                runningStartManager.stopTimer()
                if connectivityManger.isMirroring {
                    connectivityManger.sendRunningState(.pause)
                }
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
            if let course = runningStartManager.startCourse,
               runningStartManager.runningType == .gpsArt {
                CourseGuideView(
                    tapGuideView: $tapGuideView,
                    coursePathCoordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(course.coursePaths),
                    courseRotate: course.heading,
                    userLocations: locationManager.userLocations,
                    tapPossible: !(navigationTranslation + navigationSheetHeight > 10)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: tapGuideView ? .top : .topTrailing)
                .padding(.top, 80)
                .padding(.trailing, tapGuideView ? 0 : 16)
            }
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
    
    private var completeSheet: some View {
        VStack(spacing: 0) {
            Text("오늘은, 여기까지")
                .font(.customTitle2)
                .padding(.top, 56)
                .padding(.bottom, 8)
            
            Text("즐거운 러닝이었나요? 다음에 또 만나요! ")
                .font(.customSubbody)
                .padding(.bottom, 24)
            
            Image("Finish10")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.bottom, 45)
            
            CompleteButton(text: "결과 페이지로", isActive: true) {
                runningStartManager.complete = true
                withAnimation {
                    runningStartManager.running = false
                }
            }
        }
        .presentationDetents([.height(UIScreen.main.bounds.height / 2)])
        .presentationDragIndicator(.hidden)
    }
}

extension NewRunningView {
    private var navigationGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation {
                    showDetail = false
                }
                let translationY = value.translation.height
                if navigationSheetHeight == 0 {
                    navigationTranslation = min(max(translationY, -5), 150)
                } else {
                    navigationTranslation = max(min(translationY, 40), -160)
                }
            }
            .onEnded { value in
                withAnimation {
                    showDetail = false
                }
                let translationY = value.translation.height
                withAnimation(.bouncy) {
                    if translationY > 0 {
                        navigationSheetHeight = 150
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
                            navigationSheetHeight = 150
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
                DispatchQueue.main.async {
                    if runningStartManager.counter < 30 {
                        runningDataManager.stopRunningWithoutRecord()
                        runningStartManager.stopTimer()
                        runningStartManager.running = false
                        if connectivityManger.isMirroring {
                            connectivityManger.sendRunningState(.end)
                        }
                    } else {
                        Task {
                            await runningDataManager.removeActivity()
                        }
                        runningDataManager.userLocations = locationManager.userLocations
                        runningStartManager.stopTimer()
                        withAnimation {
                            showCompleteSheet = true
                        }
                        runningDataManager.stopRunning()
                        if connectivityManger.isMirroring {
                            connectivityManger.sendRunningState(.end)
                        }
                    }
                }
                showStopPopup = false
                stopButtonScale = 1
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
    NewRunningView()
}
