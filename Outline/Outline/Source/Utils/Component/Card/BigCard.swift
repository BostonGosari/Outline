//
//  BigCard.swift
//  Outline
//
//  Created by hyunjun on 11/18/23.
//

import SwiftUI
import MapKit

struct BigCard<Content: View>: View {
    @StateObject private var manager = MotionManager()
    @State private var isDragging = false
    @State private var snapShotAngle = 0.0
    @State private var rotationAngle = 0.0
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
    var editAction: (() -> Void)?
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            BigCardFrontside(
                cardType: cardType,
                runName: runName,
                date: date,
                content: content
            )
            .opacity(isFrontside ? 1 : 0)
            
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
                score: score,
                editAction: editAction
            )
            .opacity(isFrontside ? 0 : 1)            
        }
        .overlay {
            hologramOverlay
            cardBorder
        }
        .rotation3DEffect(
            .degrees(snapShotAngle + rotationAngle),
            axis: (x: 0.0, y: 1, z: 0.0),
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
    
    private var hologramOpacity: CGFloat {
        return manager.roll < 1 ? min(manager.roll * 0.5, 0.2) : 0
    }
    
    private var hologramOverlay: some View {
        ZStack {
            Image(cardType.hologramImage)
                .resizable()
                .opacity(cardType == .excellent ? 0.5 : 0.3)
                .blendMode(.overlay)
            LinearGradient(colors: [.white.opacity(hologramOpacity), .clear, .white.opacity(hologramOpacity), .clear, .white.opacity(hologramOpacity)], startPoint: .topTrailing, endPoint: .bottomLeading)
            LinearGradient(
                colors: [
                    .customCardScoreGradient1.opacity(hologramOpacity),
                    .customCardScoreGradient2.opacity(hologramOpacity),
                    .customCardScoreGradient3.opacity(hologramOpacity),
                    .customCardScoreGradient4.opacity(hologramOpacity),
                    .customCardScoreGradient5.opacity(hologramOpacity),
                    .customCardScoreGradient6.opacity(hologramOpacity),
                    .customCardScoreGradient7.opacity(hologramOpacity),
                    .customCardScoreGradient8.opacity(hologramOpacity),
                    .customCardScoreGradient9.opacity(hologramOpacity)
                ],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
        }
        .mask {
            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
        }
        .allowsHitTesting(false)
    }
    
    private var cardBorder: some View {
        UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
            .stroke(LinearGradient(
                colors: [.customCardBorderGradient1, .customCardBorderGradient2, .customCardBorderGradient3, .customCardBorderGradient4],
                startPoint: .topLeading,
                endPoint: UnitPoint(x: manager.pitch * 2, y: manager.roll * 2)), lineWidth: 2)
            .hueRotation(.degrees(90))
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
        withAnimation(.bouncy(duration: 5)) {
            rotationAngle += 360
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            isFrontside.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            isFrontside.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                cardFloatingOffset = -5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.bouncy(duration: 1.0, extraBounce: 0.65)) {
                cardFloatingOffset = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isDragable = true
        }
    }
    
    private func updateCardSide() {
        let absRotationAngle = abs(rotationAngle)
        let isOddRotation = Int((absRotationAngle + 90) / 180) % 2 != 0
        isFrontside = (isOddRotation && isFliped) || (!isOddRotation && !isFliped)
    }
}

#Preview {
    BigCard(
        cardType: .freeRun,
        runName: "오리런",
        date: "2023.11.19",
        editMode: false,
        time: "20:00.10",
        distance: "1000KM",
        pace: "9'99''",
        kcal: "100",
        bpm: "100",
        score: 100,
        editAction: {
            // edit Action here
        },
        content: {
            // Any View here
        }
    )
}
