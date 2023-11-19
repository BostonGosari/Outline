//
//  BigCard.swift
//  Outline
//
//  Created by hyunjun on 11/18/23.
//

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
    @State var translation: CGSize = .zero
    @State var isDragging = false
    @State var snapShotAngle: Double = 0
    @State var rotationAngle: Double = 0
    @State var isFrontSide = true
    @State var isFliped = false
    
    var cardType: CardType = .good
    var runName: String = "돌고래런"
    var date: String = "2023.11.19"
    
    var body: some View {
        ZStack {
            if isFrontSide {
                BigCardFrontSide(cardType: cardType, runName: runName, date: date)
            } else {
                BigCardBackSide(cardType: cardType, runName: runName, date: date)
            }
        }
        .overlay {
            VStack {
                Text("\(snapShotAngle)")
                Text("\(rotationAngle)")
                Text("\(isFliped.description)")
            }
            .background {
                Rectangle()
                    .foregroundStyle(.black)
            }
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
        .gesture(drag)
        .onAppear {
            onAppearRotateCard()
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
                    DispatchQueue.main.async {
                        updateCardSide()
                    }
                }
            }
            .onEnded { _ in
                withAnimation(.bouncy(extraBounce: 0.2)) {
                    let nearestAngle = round(rotationAngle / 180) * 180
                    rotationAngle = 0
                    snapShotAngle += nearestAngle
                }
            }
            .simultaneously(with: TapGesture()
                .onEnded { _ in
                    withAnimation(.bouncy(duration: 2)) {
                        snapShotAngle += 180
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isFrontSide.toggle()
                    }
                }
            )
    }
    
    private func onAppearRotateCard() {
        withAnimation(.bouncy(duration: 6)) {
            rotationAngle += 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            isFrontSide.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isFrontSide.toggle()
            rotationAngle = 0
        }
    }
    
    private func updateCardSide() {
        let absRotationAngle = abs(rotationAngle)
        let isOddRotation = Int((absRotationAngle + 90) / 180) % 2 != 0
        isFrontSide = (isOddRotation && isFliped) || (!isOddRotation && !isFliped)
    }
}

#Preview {
    BigCard()
}
