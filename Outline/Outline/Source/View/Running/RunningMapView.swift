//
//  RunningMapView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct RunningMapView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject private var viewModel = RunningMapViewModel()
    
    @GestureState var isLongPressed = false

    var body: some View {
        ZStack {
            RunningMap(
                locationManager: locationManager,
                viewModel: viewModel,
                coordinates: viewModel.coordinates
            )
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
            
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
        case .running:
            AnyView(
                VStack {
                    RunningStateButton(
                        imageName: "scope",
                        color: Color.white0Color,
                        size: 18
                    ) {
                        viewModel.isUserLocationCenter = true
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 32)
                    
                    HStack {
                        RunningStateButton(
                            imageName: "pause.fill",
                            color: .firstColor,
                            size: 24
                        ) {
                            viewModel.runningType = .pause
                        }
                        .padding(.trailing, 64)
                        
                        RunningStateButton(
                            imageName: "list.bullet.rectangle.portrait",
                            color: .firstColor,
                            size: 19
                        ) {
                            /*moveTo WorkoutDataView*/
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
                        .foregroundStyle(Color.black0Color)
                        .padding(24)
                        .background(
                            Circle()
                                .fill(Color.white0Color)
                        )
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
                                    /* move To FinishView */
                                }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded { _ in
                                    viewModel.isShowPopup = true
                                }
                        )
                    
                    Spacer()
                    
                    RunningStateButton(
                        imageName: "play.fill",
                        color: .firstColor,
                        size: 24
                    ) {
                        viewModel.runningType = .running
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
            Image(systemName: "\(imageName)")
                .font(.system(size: size))
                .foregroundStyle(Color.black0Color)
                .padding(size)
                .background(
                    Circle()
                        .fill(color)
                        .stroke(.white0, style: .init())
                )
        }
    }
}

#Preview {
    RunningMapView()
}
