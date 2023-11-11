//
//  MirroringView.swift
//  Outline
//
//  Created by hyunjun on 11/10/23.
//

import SwiftUI

struct MirroringView: View {
    @StateObject var workoutManager = WorkoutManager.shared
    @State var showDetail = false
    @State var isPaused = false
    @State var showDetailSheet = true
    
    @State var navigationTranslation: CGFloat = 0.0
    @State var sheetHeight: CGFloat = 0.0
    
    @Binding var showMirroringView: Bool
        
    var body: some View {
        ZStack {
            MirroringMapView()
            mirroringNavigation
        }
        .overlay {
            mirroringMetrics
        }
        .onAppear {
            workoutManager.retrieveRemoteSession()
        }
        .onChange(of: workoutManager.session?.state) { _, newValue in
            withAnimation {
                if newValue == .paused {
                    isPaused = true
                } else if newValue == .running {
                    isPaused = false
                } else {
                    showMirroringView = false
                }
            }
        }
    }
    
    private var mirroringNavigation: some View {
        MirroringNavigationView(showDetailNavigation: navigationTranslation + sheetHeight > 10)
            .frame(height: 70 + navigationTranslation + sheetHeight, alignment: .top)
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
            .gesture(gesture)
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private var mirroringMetrics: some View {
        MirroringMetricsView(showDetail: showDetail, isPaused: isPaused)
            .overlay(alignment: .topTrailing) {
                showDetailButton
            }
            .overlay(alignment: .bottom) {
                controlButton
            }
            .padding(.top, 26)
            .mask {
                RoundedRectangle(cornerRadius: 20)
            }
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.thinMaterial)
                    .ignoresSafeArea()
            }
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
        }
    }
    
    private var controlButton: some View {
        ZStack {
            Button {
                if let session = workoutManager.session {
                    session.stopActivity(with: .now )
                    session.end()
                }
                showMirroringView = false
            } label: {
                Image(systemName: "stop.circle.fill")
                    .font(.system(size: 60))
                    .fontWeight(.ultraLight)
                    .foregroundStyle(.black, .customWhite)
            }
            .frame(maxWidth: .infinity, alignment: isPaused ? .leading : .center)
            
            Button {
                withAnimation {
                    showDetail = false
                    isPaused = false
                    if let session = workoutManager.session, session.state != .running {
                        session.resume()
                    }
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
                    if sheetHeight != 0 {
                        sheetHeight = 0
                    }
                    if let session = workoutManager.session, session.state == .running {
                        session.pause()
                    }
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
    
    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let translationY = value.translation.height
                if sheetHeight == 0 {
                    navigationTranslation = min(max(translationY, -5), 340)
                } else {
                    navigationTranslation = max(min(translationY, 40), -310)
                }
            }
            .onEnded { value in
                let translationY = value.translation.height
                withAnimation(.bouncy) {
                    if translationY > 0 {
                        sheetHeight = 300
                    } else {
                        sheetHeight = 0
                    }
                    
                    navigationTranslation = 0.0
                }
            }
            .simultaneously(with: TapGesture()
                .onEnded { _ in
                    withAnimation {
                        if sheetHeight == 0 {
                            sheetHeight = 300
                        } else {
                            sheetHeight = 0
                        }
                    }
                }
            )
    }
}

#Preview {
    MirroringView(showMirroringView: .constant(true))
}
