//
//  RunningMapView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct RunningMapView: View {
    @StateObject private var viewModel = RunningMapViewModel()
    @StateObject var locationManager = LocationManager()
    @StateObject var runningManager = RunningManager.shared
    
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
                /*running Guid View*/
                Spacer()
                runningButtonView
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 80)
            }
            
            if let course = runningManager.startCourse {
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
    }
}

extension RunningMapView {
    private var runningButtonView: AnyView {
        switch viewModel.runningType {
        case .start:
            AnyView(
                VStack {
                    RunningStateButton(
                        imageName: "aim",
                        color: Color.whiteColor,
                        size: 18
                    ) {
                        viewModel.isUserLocationCenter = true
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 32)
                    
                    HStack {
                        RunningStateButton(
                            imageName: "pause.fill",
                            color: .primaryColor,
                            size: 24
                        ) {
                            viewModel.runningType = .pause
                            runningViewModel.pauseRunning()
                            digitalTimerViewModel.stopTimer()
                        }
                        .padding(.trailing, 64)
                        
                        RunningStateButton(
                            imageName: "list.bullet.rectangle.portrait",
                            color: .primaryColor,
                            size: 19
                        ) {
                            withAnimation {
                                if selection == 0 {
                                    selection = 1
                                } else {
                                    selection = 0
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 32)
                }
            )
        case .pause:
            AnyView(
                HStack {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.blackColor)
                        .padding(24)
                        .background(Circle().fill(Color.whiteColor))
                        .scaleEffect(isLongPressed ? 1.5 : 1)
                        .animation(.easeInOut(duration: 1), value: isLongPressed)
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 2.0)
                                .updating($isLongPressed) { currentState, gestureState, _ in
                                    gestureState = currentState
                                }
                                .onEnded { _ in
                                    print("Long press ended")
                                    HapticManager.impact(style: .medium)
                                    locationManager.stopUpdateLocation()
                                    homeTabViewModel.userLocations = locationManager.userLocations
                                    runningViewModel.stopRunning()
                                    digitalTimerViewModel.counter = 0
                                    showCustomSheet = true
                                }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded { _ in
                                    print("Tap gesture")
                                    viewModel.isShowPopup = true
                                }
                        )
                        .navigationDestination(isPresented: $navigateToFinishRunningView) {
                            FinishRunningView(homeTabViewModel: homeTabViewModel)
                                .navigationBarBackButtonHidden()
                        }
                    
                    Spacer()
                    
                    RunningStateButton(
                        imageName: "play.fill",
                        color: .primaryColor,
                        size: 24
                    ) {
                        viewModel.runningType = .start
                        runningViewModel.resumeRunning()
                        digitalTimerViewModel.startTimer()
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 64)
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

struct RunningStateButton: View {
    let imageName: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        }  label: {
            if imageName == "aim" {
                Image("\(imageName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size)
                    .foregroundStyle(Color.blackColor)
                    .padding(size)
                    .background(
                        Circle()
                            .fill(color)
                            .stroke(.white, style: .init())
                    )
            } else {
                Image(systemName: imageName)
                    .font(.system(size: size))
                    .foregroundStyle(Color.blackColor)
                    .padding(size)
                    .background(
                        Circle()
                            .fill(color)
                            .stroke(.white, style: .init())
                    )
            }
        }
    }
}
