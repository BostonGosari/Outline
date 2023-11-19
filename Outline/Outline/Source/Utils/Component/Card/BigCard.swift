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
    @StateObject var manager = MotionManager()
    @State var translation: CGSize = .zero
    @State var isDragging = false
    @State var snapShotAngle: Double = 0
    @State var rotationAngle: Double = 0
    @State var isFrontSide = true
    @State var isFliped = false
    @State var isDragable = false
    @State var cardFloatingOffset: CGFloat = 0
    
    var cardType: CardType = .good
    var runName: String = "돌고래런"
    var date: String = "2023.11.19"
    var editMode: Bool = false
    
    private let borderGradient = LinearGradient(
        colors: [.customCardBorderGradient1, .customCardBorderGradient2, .customCardBorderGradient3, .customCardBorderGradient4],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            if isFrontSide {
                BigCardFrontSide(cardType: cardType, runName: runName, date: date)
            } else {
                BigCardBackSide(cardType: cardType, runName: runName, date: date, editMode: editMode)
            }
        }
        .overlay {
            ZStack {
                Image(cardType.hologramImage)
                    .resizable()
                    .opacity(cardType == .excellent ? 0.4 : 0.2)
                LinearGradient(colors: [.white.opacity(manager.roll * 0.5), .clear, .white.opacity(manager.roll * 0.3), .clear, .white.opacity(manager.roll * 0.3)], startPoint: .topTrailing, endPoint: .bottomLeading)
                LinearGradient(colors: [.clear, .yellow.opacity(manager.pitch * 0.2), .clear, .yellow.opacity(manager.pitch * 0.2), .clear, .yellow.opacity(manager.pitch * 0.2), .clear], startPoint: .topTrailing, endPoint: .bottomLeading)
                LinearGradient(colors: [.blue.opacity(manager.pitch * 0.2), .clear, .blue.opacity(manager.pitch * 0.2), .clear, .blue.opacity(manager.pitch * 0.2), .clear, .blue.opacity(manager.pitch * 0.2)], startPoint: .topTrailing, endPoint: .bottomLeading)
                LinearGradient(colors: [.clear, .red.opacity(manager.roll * 0.3), .clear, .red.opacity(manager.roll * 0.2), .clear, .red.opacity(manager.roll * 0.2), .clear], startPoint: .topTrailing, endPoint: .bottomLeading)
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
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
            }
        }
        
    }
}

#Preview {
    BigCard()
}
