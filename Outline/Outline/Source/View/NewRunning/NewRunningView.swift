//
//  NewRunningView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import SwiftUI
import CoreMotion
struct NewRunningView: View {
    @StateObject private var runningStartManager = RunningStartManager.shared
    @StateObject private var runningDataManager = RunningDataManager.shared
    
    @AppStorage("isFirstRunning") private var isFirstRunning = true
    
    @State private var showDetail = false
    @State private var isPaused = false
    @State private var showDetailSheet = true
    @State private var showCompleteSheet = false
    
    @State private var navigationTranslation: CGFloat = 0.0
    @State private var navigationSheetHeight: CGFloat = 0.0
    @State private var metricsTranslation: CGFloat = 0.0
    @State private var metricsSheetHeight: CGFloat = 0.0
    @State private var stopButtonScale: CGFloat = 1
    
    var body: some View {
        ZStack {
            map
            if runningStartManager.runningType == .gpsArt {
                navigation
            }
            metrics
            RunningFinishPopUp(isPresented: $showCompleteSheet, score: .constant(60), userLocations: .constant([
                CLLocationCoordinate2D(latitude: 36.01489, longitude: 129.3324701),
                   CLLocationCoordinate2D(latitude: 36.0150809, longitude: 129.3327384),
                   CLLocationCoordinate2D(latitude: 36.015159, longitude: 129.3331031),
                   CLLocationCoordinate2D(latitude: 36.0153673, longitude: 129.3332104),
                   CLLocationCoordinate2D(latitude: 36.0154888, longitude: 129.3335645),
                   CLLocationCoordinate2D(latitude: 36.0156884, longitude: 129.3338756),
                   CLLocationCoordinate2D(latitude: 36.0159053, longitude: 129.3343477),
                   CLLocationCoordinate2D(latitude: 36.0160442, longitude: 129.3346696),
                   CLLocationCoordinate2D(latitude: 36.0161917, longitude: 129.3349163),
                   CLLocationCoordinate2D(latitude: 36.0162264, longitude: 129.3351524),
                   CLLocationCoordinate2D(latitude: 36.0163132, longitude: 129.3353026),
                   CLLocationCoordinate2D(latitude: 36.0160355, longitude: 129.3354635),
                   CLLocationCoordinate2D(latitude: 36.015914, longitude: 129.3356459),
                   CLLocationCoordinate2D(latitude: 36.0156537, longitude: 129.3357103),
                   CLLocationCoordinate2D(latitude: 36.0154801, longitude: 129.335839),
                   CLLocationCoordinate2D(latitude: 36.0152892, longitude: 129.3359034),
                   CLLocationCoordinate2D(latitude: 36.015133, longitude: 129.3360214),
                   CLLocationCoordinate2D(latitude: 36.014916, longitude: 129.3360428),
                   CLLocationCoordinate2D(latitude: 36.0146904, longitude: 129.3361394),
                   CLLocationCoordinate2D(latitude: 36.014378, longitude: 129.3362682),
                   CLLocationCoordinate2D(latitude: 36.0140395, longitude: 129.3364076),
                   CLLocationCoordinate2D(latitude: 36.0138312, longitude: 129.3365042),
                   CLLocationCoordinate2D(latitude: 36.013649, longitude: 129.3365256),
                   CLLocationCoordinate2D(latitude: 36.0134147, longitude: 129.33659),
                   CLLocationCoordinate2D(latitude: 36.013163, longitude: 129.3366651),
                   CLLocationCoordinate2D(latitude: 36.0129981, longitude: 129.336708),
                   CLLocationCoordinate2D(latitude: 36.0126944, longitude: 129.3368046),
                   CLLocationCoordinate2D(latitude: 36.0124514, longitude: 129.336869),
                   CLLocationCoordinate2D(latitude: 36.0122604, longitude: 129.3369763),
                   CLLocationCoordinate2D(latitude: 36.011984, longitude: 129.336988),
                   CLLocationCoordinate2D(latitude: 36.0116703, longitude: 129.3370192),
                   CLLocationCoordinate2D(latitude: 36.011436, longitude: 129.3367939),
                   CLLocationCoordinate2D(latitude: 36.011436, longitude: 129.3365364),
                   CLLocationCoordinate2D(latitude: 36.0113926, longitude: 129.3362682),
                   CLLocationCoordinate2D(latitude: 36.011359, longitude: 129.336076),
                   CLLocationCoordinate2D(latitude: 36.011167, longitude: 129.3361072),
                   CLLocationCoordinate2D(latitude: 36.0109847, longitude: 129.336118),
                   CLLocationCoordinate2D(latitude: 36.0108372, longitude: 129.336118),
                   CLLocationCoordinate2D(latitude: 36.010613, longitude: 129.336108),
                   CLLocationCoordinate2D(latitude: 36.0104987, longitude: 129.3359677),
                   CLLocationCoordinate2D(latitude: 36.0103946, longitude: 129.3357854),
                   CLLocationCoordinate2D(latitude: 36.010361, longitude: 129.335626),
                   CLLocationCoordinate2D(latitude: 36.0103338, longitude: 129.3353777),
                   CLLocationCoordinate2D(latitude: 36.0103338, longitude: 129.3350022),
                   CLLocationCoordinate2D(latitude: 36.0103338, longitude: 129.3347983),
                   CLLocationCoordinate2D(latitude: 36.0103338, longitude: 129.3345194),
                   CLLocationCoordinate2D(latitude: 36.0102731, longitude: 129.3343584),
                   CLLocationCoordinate2D(latitude: 36.01011, longitude: 129.334199),
                   CLLocationCoordinate2D(latitude: 36.0100214, longitude: 129.3340366),
                   CLLocationCoordinate2D(latitude: 36.0099867, longitude: 129.3338113),
                   CLLocationCoordinate2D(latitude: 36.0100127, longitude: 129.3335216),
                   CLLocationCoordinate2D(latitude: 36.0101168, longitude: 129.3332534),
                   CLLocationCoordinate2D(latitude: 36.0102991, longitude: 129.3330495),
                   CLLocationCoordinate2D(latitude: 36.01037, longitude: 129.33289),
                   CLLocationCoordinate2D(latitude: 36.0102383, longitude: 129.3327813),
                   CLLocationCoordinate2D(latitude: 36.0100821, longitude: 129.3326525),
                   CLLocationCoordinate2D(latitude: 36.010004, longitude: 129.3325667),
                   CLLocationCoordinate2D(latitude: 36.009787, longitude: 129.3322985),
                   CLLocationCoordinate2D(latitude: 36.009554, longitude: 129.332096),
                   CLLocationCoordinate2D(latitude: 36.0095267, longitude: 129.3320088),
                   CLLocationCoordinate2D(latitude: 36.0094486, longitude: 129.3317835),
                   CLLocationCoordinate2D(latitude: 36.0093705, longitude: 129.3314938),
                   CLLocationCoordinate2D(latitude: 36.0092924, longitude: 129.3313865),
                   CLLocationCoordinate2D(latitude: 36.009301, longitude: 129.3312256),
                   CLLocationCoordinate2D(latitude: 36.0093791, longitude: 129.3310969),
                   CLLocationCoordinate2D(latitude: 36.009415, longitude: 129.331002),
                   CLLocationCoordinate2D(latitude: 36.0093791, longitude: 129.3306784),
                   CLLocationCoordinate2D(latitude: 36.0093705, longitude: 129.3304531),
                   CLLocationCoordinate2D(latitude: 36.0093705, longitude: 129.3302707),
                   CLLocationCoordinate2D(latitude: 36.0094486, longitude: 129.3301527),
                   CLLocationCoordinate2D(latitude: 36.009518, longitude: 129.3300454),
                   CLLocationCoordinate2D(latitude: 36.0097263, longitude: 129.3303029),
                   CLLocationCoordinate2D(latitude: 36.0099519, longitude: 129.330496),
                   CLLocationCoordinate2D(latitude: 36.0103598, longitude: 129.3309145),
                CLLocationCoordinate2D(latitude: 36.0105681, longitude: 129.3309574),
                CLLocationCoordinate2D(latitude: 36.0106289, longitude: 129.3308072),
                CLLocationCoordinate2D(latitude: 36.0104987, longitude: 129.3306677),
                CLLocationCoordinate2D(latitude: 36.0103164, longitude: 129.3304531),
                CLLocationCoordinate2D(latitude: 36.0101516, longitude: 129.3302171),
                CLLocationCoordinate2D(latitude: 36.010004, longitude: 129.3300454),
                CLLocationCoordinate2D(latitude: 36.0099259, longitude: 129.329863),
                CLLocationCoordinate2D(latitude: 36.0101342, longitude: 129.3299703),
                CLLocationCoordinate2D(latitude: 36.010292, longitude: 129.330304),
                CLLocationCoordinate2D(latitude: 36.0106376, longitude: 129.3306462),
                CLLocationCoordinate2D(latitude: 36.0109153, longitude: 129.3308823),
                CLLocationCoordinate2D(latitude: 36.0111149, longitude: 129.3309896),
                CLLocationCoordinate2D(latitude: 36.011282, longitude: 129.331098),
                CLLocationCoordinate2D(latitude: 36.0113318, longitude: 129.3313329),
                CLLocationCoordinate2D(latitude: 36.0115141, longitude: 129.3314831),
                CLLocationCoordinate2D(latitude: 36.011705, longitude: 129.3314724),
                CLLocationCoordinate2D(latitude: 36.0119654, longitude: 129.3313222),
                CLLocationCoordinate2D(latitude: 36.0121216, longitude: 129.331129),
                CLLocationCoordinate2D(latitude: 36.0123386, longitude: 129.3310432),
                CLLocationCoordinate2D(latitude: 36.0124948, longitude: 129.3309788),
                CLLocationCoordinate2D(latitude: 36.0128506, longitude: 129.331011),
                CLLocationCoordinate2D(latitude: 36.0130589, longitude: 129.3310754),
                CLLocationCoordinate2D(latitude: 36.0132585, longitude: 129.3310754),
                CLLocationCoordinate2D(latitude: 36.0134147, longitude: 129.3310754),
                CLLocationCoordinate2D(latitude: 36.013432, longitude: 129.3310861),
                CLLocationCoordinate2D(latitude: 36.0135774, longitude: 129.3311344),
                CLLocationCoordinate2D(latitude: 36.0137032, longitude: 129.3311344),
                CLLocationCoordinate2D(latitude: 36.0139202, longitude: 129.3312015),
                CLLocationCoordinate2D(latitude: 36.0140048, longitude: 129.3312524),
                CLLocationCoordinate2D(latitude: 36.0140916, longitude: 129.331302),
                CLLocationCoordinate2D(latitude: 36.0141469, longitude: 129.331349),
                CLLocationCoordinate2D(latitude: 36.0142196, longitude: 129.331416),
                CLLocationCoordinate2D(latitude: 36.0142825, longitude: 129.3314657),
                CLLocationCoordinate2D(latitude: 36.0143454, longitude: 129.3315274),
                CLLocationCoordinate2D(latitude: 36.0144528, longitude: 129.331581),
                CLLocationCoordinate2D(latitude: 36.0145331, longitude: 129.3317808),
                CLLocationCoordinate2D(latitude: 36.0146101, longitude: 129.3318599),
                CLLocationCoordinate2D(latitude: 36.0146828, longitude: 129.3319806),
                CLLocationCoordinate2D(latitude: 36.0147782, longitude: 129.3321536),
                CLLocationCoordinate2D(latitude: 36.0148271, longitude: 129.3322931),
                CLLocationCoordinate2D(latitude: 36.0148705, longitude: 129.332391),
                CLLocationCoordinate2D(latitude: 36.01489, longitude: 129.3324701)
            ])
            )
        }
        .overlay {
            if isFirstRunning && runningStartManager.runningType == .gpsArt {
                FirstRunningGuideView(isFirstRunning: $isFirstRunning)
            }
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
                    showDetail = false
                    if runningStartManager.counter < 3 {
                        runningDataManager.stopRunningWithoutRecord()
                        runningStartManager.counter = 0
                        runningStartManager.running = false
                    } else {
                        runningStartManager.counter = 0
                        withAnimation {
                            showCompleteSheet = true
                        }
                        runningDataManager.stopRunning()
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
