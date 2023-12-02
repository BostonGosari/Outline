//
//  AppleRunView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import MapKit
import SwiftUI

struct AppleRunView: View {
    @StateObject private var appleRunManager = AppleRunManager.shared
    @GestureState private var press = false
    
    @State private var showDetail = false
    @State private var isPaused = false
    @State private var showCompleteSheet = false
    @State private var tapGuideView = false
    @State private var counter = 0
    @State private var finishAnimationProgress = 0.0
    
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
            guideView
            
            if appleRunManager.complete {
                completeSheet
                .zIndex(1)
            }
            
            if appleRunManager.finish {
                AppleRunFinishView()
                .zIndex(1)
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
        .onAppear {
            appleRunManager.startRunning()
        }
        .onChange(of: appleRunManager.progress) { _, newValue in
            if newValue == 1.0 {
                appleRunManager.complete = true
                appleRunManager.stopRunning()
            }
        }
    }
}

extension AppleRunView {
    private var map: some View {
        AppleRunMapView()
    }
        
    private var metrics: some View {
        AppleRunMetricsView(showDetail: showDetail, isPaused: isPaused)
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
                
                appleRunManager.resumeRunning()
                
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
                
                appleRunManager.pauseRunning()
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
            AppleRunCourseGuideView(
                tapGuideView: $tapGuideView,
                coursePathCoordinates: [],
                courseRotate: 0.0,
                userLocations: [],
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
    
    private var completeSheet: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 0) {
                Text("정말 완벽한 그림이에요!")
                    .font(.customTitle2)
                    .padding(.bottom, 8)
                
                Text("100% 달성하셨네요. 당신은 멋진 아티스트!")
                    .font(.customSubbody)
                ZStack {
                    VStack {
                        AppleRunGuide()
                            .trim(from: 0.0, to: finishAnimationProgress)
                            .stroke(.customPrimary, style: .init(lineWidth: 7, lineCap: .round, lineJoin: .round))
                            .frame(width: 120, height: 140)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
                                    finishAnimationProgress = 1.0
                                }
                            }
                    }
                    Confetti(counter: $counter,
                             num: 80,
                             confettis: [
                                .shape(.circle),
                                .shape(.smallCircle),
                                .shape(.triangle),
                                .shape(.square),
                                .shape(.smallSquare),
                                .shape(.slimRectangle),
                                .shape(.hexagon),
                                .shape(.star),
                                .shape(.starPop),
                                .shape(.blink)
                             ],
                             colors: [.blue, .yellow],
                             confettiSize: 8,
                             rainHeight: UIScreen.main.bounds.height,
                             radius: UIScreen.main.bounds.width
                    )
                    .onAppear {
                        counter += 1
                    }
                    
                }
                .padding(.top, 30)
                .padding(.bottom, 50)
                
                CompleteButton(text: "결과 페이지로", isActive: true) {
                    withAnimation {
                        appleRunManager.finish = true
                        appleRunManager.complete = false
                        appleRunManager.counter = 0
                    }
                }
            }
            .padding(.top, 56)
            .padding(.bottom, 32)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(.black70)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.customPrimary)
            }
            .padding(.horizontal)
        }
    }
}

extension AppleRunView {
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
                appleRunManager.pauseRunning()
                appleRunManager.complete = true
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
    AppleRunView()
}
