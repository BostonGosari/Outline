//
//  BigCard.swift
//  Outline
//
//  Created by hyunjun on 11/18/23.
//

import CoreMotion
import SwiftUI

enum CardType {
    case freeRun
    case nice
    case good
    case excellent
    
    var cardFrondSideImage: String {
        switch self {
        case .nice, .freeRun:
            "NormalCardFrontSide"
        case .good, .excellent:
            "CardFrontSide"
        }
    }
    
    var cardBackSideImage: String {
        switch self {
        case .freeRun, .nice:
            "NormalCardBackSide"
        case .good, .excellent:
            "CardBackSide"
        }
    }
    
    var hologramImage: String {
        switch self {
        case .freeRun, .nice, .good:
            "Hologram1"
        case .excellent:
            "Hologram2"
        }
    }
}

struct BigCard: View {
    @StateObject private var manager = MotionManager()
    @State private var translation: CGSize = .zero
    @State private var isDragging = false
    @State private var snapShotAngle: Double = 0
    @State private var rotationAngle: Double = 0
    @State private var isFrontSide = true
    @State private var isFliped = false
    @State private var isDragable = false
    @State private var cardFloatingOffset: CGFloat = 0
    
    var cardType: CardType = .nice
    var runName: String = "돌고래런"
    var date: String = "2023.11.19"
    var editMode: Bool = false
    var time: String = "00:00.00"
    var distance: String = "1.2KM"
    var pace: String = "9'99''"
    var kcal: String = "235"
    var bpm: String = "100"
    var score: Int = 100
    
    private let cardWidth = UIScreen.main.bounds.width * 0.815
    private let cardHeight = UIScreen.main.bounds.width * 0.815 * 1.635
    private let borderGradient = LinearGradient(
        colors: [.customCardBorderGradient1, .customCardBorderGradient2, .customCardBorderGradient3, .customCardBorderGradient4],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            if isFrontSide {
                BigCardFrontSide(
                    cardType: cardType, 
                    runName: runName,
                    date: date
                )
            } else {
                BigCardBackSide(
                    cardType: cardType,
                    runName: runName,
                    date: date,
                    editMode: editMode,
                    time: time,
                    distance: distance,
                    pace: pace,
                    kcal: kcal,
                    bpm: bpm,
                    score: score
                )
            }
        }
        .overlay {
            ZStack {
                Image(cardType.hologramImage)
                    .resizable()
                    .opacity(cardType == .excellent ? 0.4 : 0.2)
                LinearGradient(colors: [.white.opacity(manager.roll * 0.6), .clear, .white.opacity(manager.roll * 0.6), .clear, .white.opacity(manager.roll * 0.6)], startPoint: .topTrailing, endPoint: .bottomLeading)
                LinearGradient(colors: [.clear, .yellow.opacity(manager.roll * 0.2), .clear, .yellow.opacity(manager.roll * 0.2), .clear, .yellow.opacity(manager.roll * 0.2), .clear], startPoint: .topTrailing, endPoint: .bottomLeading)
                LinearGradient(colors: [.blue.opacity(manager.roll * 0.2), .clear, .blue.opacity(manager.roll * 0.2), .clear, .blue.opacity(manager.roll * 0.2), .clear, .blue.opacity(manager.roll * 0.2)], startPoint: .topTrailing, endPoint: .bottomLeading)
                LinearGradient(colors: [.clear, .red.opacity(manager.roll * 0.1), .clear, .red.opacity(manager.roll * 0.1), .clear, .red.opacity(manager.roll * 0.1), .clear], startPoint: .topTrailing, endPoint: .bottomLeading)
                LinearGradient(
                    colors: [
                        .customCardScoreGradient1.opacity(manager.roll * 0.3),
                        .customCardScoreGradient2.opacity(manager.pitch * 0.3),
                        .customCardScoreGradient3.opacity(manager.roll * 0.3),
                        .customCardScoreGradient4.opacity(manager.pitch * 0.3),
                        .customCardScoreGradient5.opacity(manager.roll * 0.3),
                        .customCardScoreGradient6.opacity(manager.pitch * 0.3),
                        .customCardScoreGradient7.opacity(manager.roll * 0.3),
                        .customCardScoreGradient8.opacity(manager.pitch * 0.3),
                        .customCardScoreGradient9.opacity(manager.roll * 0.3)
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            }
            .mask {
                UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
            }
            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                .stroke(LinearGradient(
                    colors: [.customCardBorderGradient1, .customCardBorderGradient2, .customCardBorderGradient3, .customCardBorderGradient4],
                    startPoint: .topLeading,
                    endPoint: UnitPoint(x: manager.pitch * 2, y: manager.roll * 2)), lineWidth: 2)
                .hueRotation(.degrees(90))
        }
        .rotation3DEffect(
            .degrees(snapShotAngle + rotationAngle),
            axis: (
                x: 0.0,
                y: 1,
                z: 0.0
            ),
            perspective: 0.3
        )
        .offset(y: cardFloatingOffset)
        .gesture(isDragable ? drag : nil)
        .onAppear {
            onAppearCardAnimation()
        }
        .onChange(of: snapShotAngle) { oldValue, newValue in
            if abs(Int(newValue - oldValue)) / 180 % 2 > 0 {
                isFliped.toggle()
            }
        }
    }
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.bouncy) {
                    rotationAngle = value.translation.width * 2
                    updateCardSide()
                }
            }
            .onEnded { _ in
                DispatchQueue.main.async {
                    let nearestAngle = round(rotationAngle / 180) * 180
                    withAnimation(.bouncy(extraBounce: 0.2)) {
                        rotationAngle = 0
                        snapShotAngle += nearestAngle
                    }
                }
            }
            .simultaneously(with: TapGesture()
                .onEnded { _ in
                    withAnimation(.bouncy(duration: 1.5)) {
                        snapShotAngle += 180
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isFrontSide.toggle()
                    }
                }
            )
    }
    
    private func onAppearCardAnimation() {
        withAnimation(.bouncy(duration: 4)) {
            rotationAngle += 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFrontSide.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isFrontSide.toggle()
            rotationAngle = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeIn(duration: 0.5)) {
                cardFloatingOffset = -5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.bouncy(duration: 1.5, extraBounce: 0.65)) {
                cardFloatingOffset = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isDragable = true
        }
    }
    
    private func updateCardSide() {
        let absRotationAngle = abs(rotationAngle)
        let isOddRotation = Int((absRotationAngle + 90) / 180) % 2 != 0
        isFrontSide = (isOddRotation && isFliped) || (!isOddRotation && !isFliped)
    }
}

final class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    private var manager: CMMotionManager
    
    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            if let motionData = motionData {
                self.pitch = abs(motionData.attitude.pitch)
                self.roll = abs(motionData.attitude.roll)
            }
        }
        
    }
}

#Preview {
    BigCard()
}
