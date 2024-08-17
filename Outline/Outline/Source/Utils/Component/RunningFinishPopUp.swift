//
//  RunningFinishPopUp.swift
//  Outline
//
//  Created by 김하은 on 11/18/23.
//

import SwiftUI
import CoreMotion

enum ScoreState {
    case freerun
    case notyet
    case nice
    case great
    case excellent
}

struct RunningFinishPopUp: View {
    @StateObject private var runningStartManager = RunningStartManager.shared
    @StateObject private var runningDataManager = RunningDataManager.shared
    @State private var counter = 0
    @State private var progress = 0.0

    @Binding var isPresented: Bool
    @Binding var score: Int
    @Binding var userLocations: [CLLocationCoordinate2D]
    @Binding var isResumeRunning: Bool
    
    private var canvasData: CanvasData {
        return PathManager.getCanvasData(coordinates: userLocations, width: 200, height: 200)
    }
   
    var scoreState: ScoreState {
        if score == -1 {
            return .freerun
        } else if score == 0 {
            return .notyet
        } else if score < 50 {
            return .nice
        } else if score < 90 {
            return .great
        } else {
            return .excellent
        }
    }

    var body: some View {
        if isPresented {
            ZStack {
                Color.black50
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                VStack(spacing: 0) {
                    switch scoreState {
                    case .freerun:
                        freerunContent()
                    case .notyet, .nice, .great, .excellent:
                        gpsrunContent()
                    }
                    
                    Spacer()
                    
                    CompleteButton(text: "결과 페이지로", isActive: true) {
                        isPresented = false
                        runningStartManager.complete = true
                        runningDataManager.doneRunning()
                        withAnimation {
                            runningStartManager.running = false
                        }
                        Task {
                            print("여기옴")
                            await runningDataManager.removeActivity()
                        }
                    }
                    UnderlineButton(text: "조금 더 진행하기") {
                        progress = 0
                        isResumeRunning = true
                        isPresented = false
                    }
                }
                .padding(EdgeInsets(top: 42, leading: 16, bottom: 32, trailing: 16))
                .background(.black70)
                .cornerRadius(25)
                .frame(maxWidth: .infinity, maxHeight: scoreState == .freerun ? 505 : 600)
                .padding(.horizontal, 16)
                .foregroundColor(.clear)
              
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .inset(by: 0.5)
                        .stroke(.customPrimary)
                        .padding(.horizontal, 16)
                )
                
                if score > 50 {
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
                }
            }
            .onAppear {
                counter += 1
            }
            .zIndex(2)
        }
    }
    
    private func gpsrunContent() -> some View {
        VStack(spacing: 0) {
            Image(scoreState.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                .offset(x: scoreState.offset)
            Text(scoreState.title)
                .font(.customTitle2)
                .foregroundStyle(.customWhite)
                .padding(.top, 8)
            Text(scoreState.subtitle)
                .font(.customSubbody)
                .foregroundStyle(.gray300)
                .padding(.top, 8)
            Spacer()
            PathManager.createPath(width: 200, height: 200, coordinates: userLocations)
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.customPrimary)
                .frame(width: canvasData.width, height: canvasData.height)
                .frame(width: 200, height: 200)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                        progress = 1.0
                    }
                }
            Spacer()
        }
    }
    
    private func freerunContent() -> some View {
        VStack(spacing: 0) {
            Text(scoreState.title)
                .font(.customTitle2)
                .foregroundStyle(.customWhite)
                .padding(.top, 24)
            Text(scoreState.subtitle)
                .font(.customSubbody)
                .foregroundStyle(.gray300)
                .padding(.top, 8)
            Image(scoreState.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 169)
                .padding(.top, 38)
        }
    }
}

extension ScoreState {
    var imageName: String {
        switch self {
        case .freerun: return "freerun"
        case .notyet: return "notyet"
        case .nice: return "nice"
        case .great: return "great"
        case .excellent: return "excellent"
        }
    }

    var title: String {
        switch self {
        case .freerun: return "오늘은, 여기까지"
        case .notyet, .nice: return "오늘은, 여기까지"
        case .great: return "신나는 러닝이었나요?"
        case .excellent: return "정말 완벽한 그림이에요!"
        }
    }

    var subtitle: String {
        switch self {
        case .freerun: return "즐거운 러닝이었나요? 다음에 또 만나요!"
        case .notyet, .nice: return "다음에는 완성해봐요. 또 만나요!"
        case .great: return "50%이상 달성하셨네요! 다음에도 함께해요"
        case .excellent: return "100% 달성하셨네요. 당신은 멋진 아티스트!"
        }
    }

    var offset: CGFloat {
        switch self {
        case .freerun, .notyet, .excellent: return 0
        case .nice, .great: return -15
        }
    }
}

#Preview {
    RunningFinishPopUp(isPresented: .constant(true), score: .constant(60), userLocations: .constant([
        CLLocationCoordinate2D(latitude: 37.8325, longitude: -122.4794),
        CLLocationCoordinate2D(latitude: 37.8311, longitude: -122.4839),
        CLLocationCoordinate2D(latitude: 37.8281, longitude: -122.4859)
    ]), isResumeRunning: .constant(false))
}
