//
//  RunningMapView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.
//

import MapKit
import SwiftUI

struct RunningMapView: View {
    @StateObject private var viewModel = RunningMapViewModel()
    @StateObject var runningManager = RunningManager.shared
    
    @ObservedObject var runningViewModel: RunningViewModel
    
    @GestureState var isLongPressed = false
    
    @State private var moveToFinishRunningView = false
    @State private var showCustomSheet = false
    @State private var showBigGuide = false
    
    @State private var checkUserLocation = true
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    @Binding var selection: Int
    
    var courses: [CLLocationCoordinate2D] = []
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position) {
                UserAnnotation { userlocation in
                    ZStack {
                        Circle().foregroundStyle(.white).frame(width: 22)
                        Circle().foregroundStyle(.customPrimary).frame(width: 17)
                    }
                    .onChange(of: userlocation.location) { _, userlocation in
                        if let user = userlocation, let startCourse = runningManager.startCourse {
                            if viewModel.userLocations.isEmpty {
                                viewModel.startLocation = CLLocation(latitude: user.coordinate.latitude, longitude: user.coordinate.longitude)
                            }
                            viewModel.userLocations.append(user.coordinate)
                            viewModel.checkEndDistance()
                            
                            if !startCourse.coursePaths.isEmpty {
                                runningManager.trackingDistance()
                            }
                        }
                    }
                }
                
                if let courseGuide = runningManager.startCourse {
                    MapPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(courseGuide.coursePaths))
                        .stroke(.white.opacity(0.5), lineWidth: 8)
                }
                
                MapPolyline(coordinates: viewModel.userLocations)
                    .stroke(.customPrimary, lineWidth: 8)
                
            }
            
            VStack(spacing: 0) {
                Spacer()
                runningButtonView
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 80)
            }
            
            if let course = runningManager.startCourse,
               runningManager.runningType == .gpsArt {
                CourseGuideView(
                    userLocations: $viewModel.userLocations,
                    showBigGuide: $showBigGuide,
                    coursePathCoordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(course.coursePaths),
                    courseRotate: course.heading
                )
                .onTapGesture {
                    showBigGuide.toggle()
                    // TODO: 햅틱 추가
                }
                .animation(.openCard, value: showBigGuide)
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
        .overlay {
            if viewModel.isShowComplteSheet {
                runningFinishSheet()
            }
        }
        .overlay {
            if viewModel.isNearEndLocation {
                RunningPopup(text: "도착 지점까지 30m 남았어요.")
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .navigationDestination(isPresented: $moveToFinishRunningView) {
            FinishRunningView()
                .navigationBarBackButtonHidden()
        }
    }
}

extension RunningMapView {
    @ViewBuilder
    private var runningButtonView: some View {
        ZStack {
            switch viewModel.runningType {
            case .start:
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
                            runningManager.stopTimer()
                        } label: {
                            Image(systemName: "pause.fill")
                                .buttonModifier(color: Color.customPrimary, size: 29, padding: 29)
                            
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
                                .imageButtonModifier(color: Color.customPrimary, size: 24, padding: 18)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 32)
                }
                .transition(.slide)
            case .pause:
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
                                        checkUserLocation = false
                                        viewModel.saveData(course: runningManager.startCourse)
                                        runningViewModel.stopRunning()
                                        runningManager.counter = 0
                                        showCustomSheet = true
                                    }
                                }
                        )
                    
                    Spacer()
                    
                    Button {
                        HapticManager.impact(style: .medium)
                        viewModel.runningType = .start
                        runningViewModel.resumeRunning()
                        runningManager.startTimer()
                    } label: {
                        Image(systemName: "play.fill")
                            .buttonModifier(color: Color.customPrimary, size: 24, padding: 26)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 64)
                .transition(.slide)
            case .stop:
                EmptyView()
            }
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
                moveToFinishRunningView = true
            }
        }
        .presentationDetents([.height(420)])
        .presentationCornerRadius(35)
        .interactiveDismissDisabled()
    }
    
    @ViewBuilder
    private func runningFinishSheet() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.customPrimary)
                .fill(Color.black70)
            
            VStack(alignment: .center, spacing: 0) {
                Text("그림을 완성했어요!")
                    .font(.title2)
                    .padding(.top, 73)
                    .padding(.bottom, 20)
                
                Text("5m이내에 도착지점이 있어요")
                    .font(.subBody)
                    .foregroundStyle(Color.gray300)
                
                Text("러닝을 완료할까요?")
                    .font(.subBody)
                    .foregroundStyle(Color.gray300)
                    .padding(.bottom, 41)
                
                CompleteButton(text: "완료하기", isActive: true) {
                    moveToFinishRunningView = true
                }
                .padding(.bottom, 24)
                
                Button {
                    viewModel.isShowComplteSheet = false
                } label: {
                    Text("조금 더 진행하기")
                        .foregroundStyle(Color.white)
                        .font(.button)
                        .padding(.bottom, 37)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(EdgeInsets(top: 422, leading: 8, bottom: 34, trailing: 8))
    }
}

extension Image {
    func imageButtonModifier(color: Color, size: CGFloat, padding: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: size)
            .foregroundStyle(Color.customBlack)
            .padding(padding)
            .background(
                Circle()
                    .fill(color)
            )
    }
    
    func buttonModifier(color: Color, size: CGFloat, padding: CGFloat) -> some View {
        self
            .font(.system(size: size))
            .foregroundStyle(Color.customBlack)
            .padding(padding)
            .background(
                Circle()
                    .fill(color)
                    .stroke(.white, style: .init())
            )
    }
}
