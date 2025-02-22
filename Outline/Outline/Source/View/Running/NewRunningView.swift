//
//  NewRunningView.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/21/25.
//

import SwiftUI
import CoreMotion

struct NewRunningView: View {
    @StateObject private var viewModel = RunningViewModel()

    var body: some View {
        ZStack {
            map
//            if let startCourse = runningStartManager.startCourse,
//                !startCourse.navigation.isEmpty {
//                navigation
//            }
            metrics
            guideView

            RunningFinishPopUp()
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.onAppear()
        }
        .overlay {
            if viewModel.isFirstRunning && viewModel.runningType == .gpsArt {
                FirstRunningGuideView(isFirstRunning: $viewModel.isFirstRunning)
            }
        }
        .overlay {
            if viewModel.showStopPopup {
                RunningPopup(text: "정지 버튼을 길게 누르면 러닝이 종료돼요")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

extension NewRunningView {
    private var map: some View {
        RunningMapView(userLocations: viewModel.userLocations)
            .ignoresSafeArea()
    }
    private var metrics: some View {
        RunningMetricsView()
            .overlay(alignment: .topTrailing) {
                showDetailButton
            }
            .padding(.top, 26)
            .frame(height: viewModel.showDetailMetrics ? 360 + viewModel.metricsTranslation : getSafeArea().bottom == 0 ? 110 : 80, alignment: .top)

            .mask {
                RoundedRectangle(cornerRadius: 20)
            }
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 6, opaque: true)
                    .offset(y: getSafeArea().bottom == 0 ? 20 : 0)
                    .ignoresSafeArea()
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.black50)
                            .ignoresSafeArea()
                            .offset(y: getSafeArea().bottom == 0 ? 20 : 0)
                    }
            }
//                .gesture(metricsGesture)
            .overlay(alignment: .bottom) {
                controlButton
            }
            .zIndex(1)
            .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private var showDetailButton: some View {
        Button {
            viewModel.toggleShowDetailButton()
        } label: {
            Image(systemName: "chevron.up.circle.fill")
                .rotationEffect(viewModel.showDetailMetrics ? .degrees(-180) : .degrees(0))
                .font(.system(size: 35))
                .padding(.trailing, 16)
                .foregroundStyle(.gray600, .gray700)
                .fontWeight(.semibold)
        }
        .offset(y: getSafeArea().bottom == 0 ? 20 : 0)
    }

    private var controlButton: some View {
        ZStack {
            Button {
                viewModel.tapStopRunningButton()
            } label: {
                Image(systemName: "stop.circle.fill")
                    .font(.system(size: 60))
                    .fontWeight(.ultraLight)
                    .foregroundStyle(.black, .customWhite)
                    .gesture(stopButtonGesture)
                    .scaleEffect(viewModel.onPressStopButton ? 1.5 : 1)
            }
            .animation(.easeInOut, value: viewModel.onPressStopButton)
            .frame(maxWidth: .infinity, alignment: viewModel.isPaused ? .leading : .center)

            Button {
                viewModel.tapResumeRunningButton()
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
            .frame(maxWidth: .infinity, alignment: viewModel.isPaused ? .trailing : .center)

            Button {
                viewModel.tapPauseRunningButton()
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
            .opacity(viewModel.isPaused ? 0 : 1)
            .animation(nil, value: viewModel.isPaused)
            .zIndex(1)
        }
        .padding(.horizontal, 90)
        .offset(y: getSafeArea().bottom == 0 ? -10 : 0)
    }

    private var guideView: some View {
        ZStack {
            //            if let course = runningStartManager.startCourse,
            //               runningStartManager.runningType == .gpsArt {
            //                CourseGuideView(
            //                    tapGuideView: $tapGuideView,
            //                    coursePathCoordinates: course.coursePaths.toCLLocationCoordinates(),
            //                    courseRotate: course.heading,
            //                    userLocations: locationManager.userLocations,
            //                    tapPossible: !(navigationTranslation + navigationSheetHeight > 10)
            //                )
            //                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: tapGuideView ? .top : .topTrailing)
            //                .padding(.top, 80)
            //                .padding(.trailing, tapGuideView ? 0 : 16)
            //            }
            //        }
            //        .zIndex(tapGuideView ? 2 : 0)
            //        .background {
            //            if tapGuideView {
            //                Color.black50.ignoresSafeArea()
            //                    .onTapGesture {
            //                        withAnimation {
            //                            tapGuideView = false
            //                        }
            //                    }
            //            }
            //        }
        }
    }
}
extension NewRunningView {
//    private var navigationGesture: some Gesture {
//        DragGesture()
//            .onChanged { value in
//                withAnimation {
//                    showDetail = false
//                }
//                let translationY = value.translation.height
//                if navigationSheetHeight == 0 {
//                    navigationTranslation = min(max(translationY, -5), 150)
//                } else {
//                    navigationTranslation = max(min(translationY, 40), -160)
//                }
//            }
//            .onEnded { value in
//                withAnimation {
//                    showDetail = false
//                }
//                let translationY = value.translation.height
//                withAnimation(.bouncy) {
//                    if translationY > 0 {
//                        navigationSheetHeight = 150
//                    } else {
//                        navigationSheetHeight = 0
//                    }
//                    navigationTranslation = 0.0
//                }
//            }
//            .simultaneously(with: TapGesture()
//                .onEnded { _ in
//                    withAnimation {
//                        showDetail = false
//                    }
//                    withAnimation {
//                        if navigationSheetHeight == 0 {
//                            navigationSheetHeight = 150
//                        } else {
//                            navigationSheetHeight = 0
//                        }
//                    }
//                }
//            )
//    }

//    private var metricsGesture: some Gesture {
//        DragGesture()
//            .onChanged { value in
//                if !isPaused {
//                    let translationY = value.translation.height
//                    if showDetail {
//                        withAnimation {
//                            metricsTranslation = min(-translationY, 30)
//                            navigationTranslation = 0
//                        }
//                    }
//                }
//            }
//            .onEnded { value in
//                if !isPaused {
//                    let translationY = value.translation.height
//                    if showDetail {
//                        withAnimation(.bouncy) {
//                            if translationY > 0 {
//                                showDetail = false
//                            }
//                            metricsTranslation = 0.0
//                            navigationTranslation = 0
//                        }
//                    }
//                }
//            }
//    }

    private var stopButtonGesture: some Gesture {
        LongPressGesture(minimumDuration: 1.5)
            .updating(viewModel.$onPressStopButton) { (currentState, gestureState, _) in
                gestureState = currentState
            }
            .onEnded { _ in
                viewModel.onEndedLongpreseGesture()
            }
            .simultaneously(with: TapGesture()
                .onEnded { _ in
                    viewModel.onEndedTapGesture()
                }
            )
    }
}

#Preview {
    NewRunningView()
}
