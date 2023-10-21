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
    
    @ObservedObject var runningViewModel: RunningViewModel
    @ObservedObject var vm: HomeTabViewModel
    
    @GestureState var isLongPressed = false
    
    @Binding var selection: Int
    
    var body: some View {
        ZStack {
            if let course = vm.startCourse {
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
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 2.0)
                                .updating($isLongPressed) { currentState, gestureState, _ in
                                    gestureState = currentState
                                    if currentState {
                                        giveHapticFeedback()
                                    }
                                }
                                .onEnded { _ in
                                    print("Long press ended")
                                    runningViewModel.stopRunnning()
                                }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded { _ in
                                    print("Tap gesture")
                                    viewModel.isShowPopup = true
                                }
                        )
                    
                    Spacer()
                    
                    RunningStateButton(
                        imageName: "play.fill",
                        color: .primaryColor,
                        size: 24
                    ) {
                        viewModel.runningType = .start
                        runningViewModel.resumeRunning()
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
    
    private func giveHapticFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
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
