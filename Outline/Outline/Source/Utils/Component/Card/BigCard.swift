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
    
    var cardType: CardType = .excellent
    var runName: String = "돌고래런"
    var date: String = "2023.11.19"
    
    var body: some View {
        ZStack {
            if isFrontSide {
                BigCardFrontSide(cardType: cardType, runName: runName, date: date)
            } else {
                BigCardBackSide(cardType: cardType)
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
            rotateCard()
        }
    }
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.bouncy) {
                    rotationAngle = value.translation.width * 2
                    DispatchQueue.main.async {
                        if 0...90 ~= abs(rotationAngle) {
                            isFrontSide = true
                        } else if 90...270 ~= abs(rotationAngle) {
                            isFrontSide = false
                        } else if 270...450 ~= abs(rotationAngle) {
                            isFrontSide = true
                        } else if 450...630 ~= abs(rotationAngle) {
                            isFrontSide = false
                        } else if 630...810 ~= abs(rotationAngle) {
                            isFrontSide = false
                        }
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
    
    private func rotateCard() {
        withAnimation(.bouncy(duration: 6)) {
            rotationAngle += 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isFrontSide.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            isFrontSide.toggle()
            rotationAngle = 0
        }
    }
}

#Preview {
    BigCard()
}
