//
//  NewRunningView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import SwiftUI

struct NewRunningView: View {
    @StateObject var runningStartManager = RunningStartManager.shared
    @StateObject var runningDataManager = RunningDataManager.shared
    
    @AppStorage("isFirstRunning") var isFirstRunning = true
    
    @State var showDetail = false
    @State var isPaused = false
    @State var showDetailSheet = true
    @State private var showCompleteSheet = false
    
    @State var navigationTranslation: CGFloat = 0.0
    @State var navigationSheetHeight: CGFloat = 0.0
    @State var metricsTranslation: CGFloat = 0.0
    @State var metricsSheetHeight: CGFloat = 0.0
    @State var stopButtonScale: CGFloat = 1
    
    var body: some View {
        ZStack {
            map
            if runningStartManager.runningType == .gpsArt {
                navigation
            }
            metrics
        }
        .overlay {
            if isFirstRunning && runningStartManager.runningType == .gpsArt {
                FirstRunningGuideView(isFirstRunning: $isFirstRunning)
            }
        }
        .sheet(isPresented: $showCompleteSheet) {
            completeSheet
        }
    }
}

extension NewRunningView {
    private var map: some View {
        NewRunningMapView()
            .onAppear {
                if runningStartManager.running == true {
                    runningDataManager.startRunning()
                    runningStartManager.startTimer()
                }
            }
    }
    
    private var navigation: some View {
        NewRunningNavigationView(showDetailNavigation: navigationTranslation + navigationSheetHeight > 10)
            .frame(height: 70 + navigationTranslation + navigationSheetHeight, alignment: .top)
            .mask {
                Rectangle()
                    .roundedCorners(50, corners: .bottomRight)
            }
            .background {
                Rectangle()
                    .roundedCorners(50, corners: .bottomRight)
                    .foregroundStyle(.thinMaterial)
                    .ignoresSafeArea()
                    .overlay(alignment: .bottom) {
                        Capsule()
                            .frame(width: 40, height: 3)
                            .padding(.bottom, 9)
                            .foregroundStyle(.gray600)
                    }
            }
            .zIndex(1)
            .gesture(navigationGesture)
            .frame(maxHeight: .infinity, alignment: .top)
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
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.thinMaterial)
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
            }
        } label: {
            Image(systemName: "chevron.up.circle.fill")
                .rotationEffect(showDetail ? .degrees(-180) : .degrees(0))
                .font(.system(size: 35))
                .padding(.trailing, 16)
                .foregroundStyle(.gray600, .gray800)
                .fontWeight(.semibold)
                .opacity(isPaused ? 0 : 1)
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
                    .scaleEffect(stopButtonScale)
            }
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
                let translationY = value.translation.height
                if navigationSheetHeight == 0 {
                    navigationTranslation = min(max(translationY, -5), 340)
                } else {
                    navigationTranslation = max(min(translationY, 40), -310)
                }
            }
            .onEnded { value in
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
                        metricsTranslation = min(-translationY, 30)
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
                        }
                    }
                }
            }
    }
    
    private var stopButtonGesture: some Gesture {
        LongPressGesture(minimumDuration: 2)
            .onChanged { _ in
                withAnimation {
                    stopButtonScale = 1.3
                }
            }
            .onEnded { _ in
                DispatchQueue.main.async {
                    if runningStartManager.counter < 3 {
                        runningDataManager.stopRunningWithoutRecord()
                        runningStartManager.counter = 0
                        runningStartManager.running = false
                    } else {
                        runningDataManager.stopRunning()
                        runningStartManager.counter = 0
                        withAnimation {
                            showCompleteSheet = true
                        }
                    }
                }
            }
            .simultaneously(with: TapGesture()
                .onEnded { _ in
                    withAnimation {
                        stopButtonScale = 1
                        //TODO: show Popup
                    }
                }
            )
    }
}

#Preview {
    NewRunningView()
}
