//
//  RunningMapView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct RunningMapView: View {
    @StateObject private var viewModel = RunningMapViewModel()
    @StateObject var runningManager = RunningManager.shared
    
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var runningViewModel: RunningViewModel
    @ObservedObject var digitalTimerViewModel: DigitalTimerViewModel
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    
    @GestureState var isLongPressed = false
    
    @Binding var selection: Int
    
    @State var navigateToFinishRunningView = false
    @State var showCustomSheet = false
    @State var showBigGuid = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let course = runningManager.startCourse {
                RunningMap(
                    locationManager: locationManager,
                    viewModel: viewModel,
                    coordinates: convertToCLLocationCoordinates(course.coursePaths)
                )
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
            }
                
            VStack(spacing: 0) {
                Spacer()
                runningButtonView
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 80)
            }
            
            if let course = runningManager.startCourse,
               runningManager.runningType == .gpsArt {
                CourseGuidView(
                    userLocations: $locationManager.userLocations,
                    showBigGuid: $showBigGuid,
                    coursePathCoordinates: convertToCLLocationCoordinates(course.coursePaths),
                    courseRotate: course.heading
                )
                    .onTapGesture {
                        showBigGuid.toggle()
                        // TODO: 햅틱 추가
                    }
                //                .animation(.easeInOut, value: showBigGuid)
                    .animation(.openCard, value: showBigGuid)
            }
        }
        .sheet(isPresented: $showCustomSheet) {
            customSheet
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: viewModel.popupText)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .navigationDestination(isPresented: $navigateToFinishRunningView) {
            FinishRunningView(homeTabViewModel: homeTabViewModel)
                .navigationBarBackButtonHidden()
        }
    }
}

extension RunningMapView {
    private var runningButtonView: AnyView {
        switch viewModel.runningType {
        case .start:
            AnyView(
                VStack(spacing: 0) {
                    Button {
                        HapticManager.impact(style: .medium)
                        viewModel.isUserLocationCenter = true
                    } label: {
                        Image("aim")
                            .imageButtonModifier(color: Color.white, size: 22, padding: 19)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 32)
                    .padding(.bottom, 14)
                    
                    HStack {
                        Button {
                            HapticManager.impact(style: .medium)
                            viewModel.runningType = .pause
                            runningViewModel.pauseRunning()
                            digitalTimerViewModel.stopTimer()
                        } label: {
                            Image(systemName: "pause.fill")
                                .buttonModifier(color: Color.primaryColor, size: 29, padding: 29)
                            
                        }
                        .padding(.trailing, 64)
                        
                        Button {
                            withAnimation {
                                if selection == 0 {
                                    selection = 1
                                } else {
                                    selection = 0
                                }
                            }
                        } label: {
                            Image("Data")
                                .imageButtonModifier(color: Color.primaryColor, size: 24, padding: 18)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 32)
                }
                    .transition(.slide)
            )
        case .pause:
            AnyView(
                HStack(spacing: 0) {
                    Image(systemName: "stop.fill")
                        .buttonModifier(color: Color.white, size: 24, padding: 26)
                        .scaleEffect(isLongPressed ? 1.6 : 1)
                        .animation(.easeInOut(duration: 0.5), value: isLongPressed)
                        .gesture(
                            LongPressGesture(minimumDuration: 2)
                                .updating($isLongPressed) { currentState, gestureState, _ in
                                    gestureState = currentState
                                    HapticManager.impact(style: .medium)

                                    if !isLongPressed {
                                        DispatchQueue.main.async {
                                            viewModel.isShowPopup = true
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    HapticManager.impact(style: .heavy)
                                    DispatchQueue.main.async {
                                        locationManager.stopUpdateLocation()
                                        homeTabViewModel.userLocations = locationManager.userLocations
                                        runningViewModel.stopRunning()
                                        digitalTimerViewModel.counter = 0
                                        showCustomSheet = true
                                    }
                                }
                        )
            
                    Spacer()
                    
                    Button {
                        HapticManager.impact(style: .medium)
                        viewModel.runningType = .start
                        runningViewModel.resumeRunning()
                        digitalTimerViewModel.startTimer()
                    } label: {
                        Image(systemName: "play.fill")
                            .buttonModifier(color: Color.primaryColor, size: 24, padding: 26)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 64)
                .transition(.slide)
            )
        case .stop:
            AnyView(
                EmptyView()
            )
        }
    }
    
    private var customSheet: some View {
        VStack(spacing: 0) {
            Text("오늘은, 여기까지")
                .font(.title2)
                .padding(.top, 56)
                .padding(.bottom, 8)
            Text("즐거운 러닝이었나요? 다음에 또 만나요! ")
                .font(.subBody)
                .padding(.bottom, 24)
            
            Image("Finish10")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.bottom, 45)
            
            CompleteButton(text: "결과 페이지로", isActive: true) {
                showCustomSheet = false
                navigateToFinishRunningView = true
            }
        }
        .presentationDetents([.height(420)])
        .presentationCornerRadius(35)
        .interactiveDismissDisabled()
    }
}

extension Image {
    func imageButtonModifier(color: Color, size: CGFloat, padding: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: size)
            .foregroundStyle(Color.blackColor)
            .padding(padding)
            .background(
                Circle()
                    .fill(color)
            )
    }
    
    func buttonModifier(color: Color, size: CGFloat, padding: CGFloat) -> some View {
        self
            .font(.system(size: size))
            .foregroundStyle(Color.blackColor)
            .padding(padding)
            .background(
                Circle()
                    .fill(color)
                    .stroke(.white, style: .init())
            )
    }
}
