//
//  BigCard.swift
//  Outline
//
//  Created by hyunjun on 11/18/23.
//

import CoreMotion
import SwiftUI

struct BigCard: View {
    @StateObject private var manager = MotionManager()
    @State private var translation: CGSize = .zero
    @State private var isDragging = false
    @State private var snapShotAngle: Double = 0
    @State private var rotationAngle: Double = 0
    @State private var isFrontside = true
    @State private var isFliped = false
    @State private var isDragable = false
    @State private var cardFloatingOffset: CGFloat = 0
    
    // Card data
    var cardType: CardType = .nice
    var runName: String = "돌고래런"
    var date: String = "2023.11.19"
    var editMode: Bool = false
    
    // BacksideCard data
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
            if isFrontside {
                BigCardFrontside(
                    cardType: cardType, 
                    runName: runName,
                    date: date
                )
            } else {
                BigCardBackside(
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
                LinearGradient(
                    colors: [
                        .customCardScoreGradient1.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient2.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient3.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient4.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient5.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient6.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient7.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient8.opacity(min(manager.roll * 0.5, 0.5)),
                        .customCardScoreGradient9.opacity(min(manager.roll * 0.5, 0.5))
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
                        isFrontside.toggle()
                    }
                }
            )
    }
    
    private func onAppearCardAnimation() {
        withAnimation(.bouncy(duration: 4)) {
            rotationAngle += 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFrontside.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isFrontside.toggle()
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
        isFrontside = (isOddRotation && isFliped) || (!isOddRotation && !isFliped)
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
