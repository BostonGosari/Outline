//
//  SlideToUnlock.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct SlideToUnlock: View {
    
    @State var isUnlocked = false
    
    private let maxWidth: CGFloat = 320
    private let minWidth: CGFloat = 70
    @State private var width: CGFloat = 70
    
    @State private var hueRotation = false
    @State private var isButtonPressed = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            backGround
            slideButton
        }
        .frame(width: 320, height: minWidth)
    }
    
    // MARK: - View Components
    
    var slideButton: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [.primaryColor, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: minWidth)
            .overlay(alignment: .trailing) {
                dragCircle
            }
            .simultaneousGesture(drag)
            .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0), value: width)
            .hueRotation(.degrees(hueRotation ? 10 : -10))
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
                    hueRotation.toggle()
                }
            }
    }
    
    var backGround: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(.thinMaterial)
            LinearGradient(
                colors: [.primaryColor, .white],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                Text("밀어서 시작하기")
                    .font(.title3)
                    .bold()
            )
            .frame(maxWidth: .infinity)
        }
    }
    
    var dragCircle: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
            if isUnlocked {
                ProgressView()
                    .tint(.purple)
                    .controlSize(.large)
            } else {
                Image(systemName: "paintbrush.fill")
                    .foregroundColor(.purple)
                    .font(.title)
            }
        }
        .scaleEffect(0.9)
    }
    
    // MARK: - Drag Gesture
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.width > 0 {
                    width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                }
            }
            .onEnded { _ in
                guard !isUnlocked else { return }
                if width < maxWidth {
                    width = minWidth
                } else {
                    withAnimation(.spring().delay(0.5)) {
                        isUnlocked = true
                    }
                }
            }
    }
}

#Preview {
    SlideToUnlock()
}
