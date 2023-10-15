//
//  SlideToUnlock.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct SlideToUnlock: View {
    
    @State var isUnlocked = false
    
    let maxWidth: CGFloat = 320
    
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
                    colors: [.firstColor, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: minWidth)
            .overlay(alignment: .trailing) {
                Button { } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                        if isUnlocked {
                            ProgressView()
                                .tint(.purple)
                                .controlSize(.large)
                        } else {
                            Image(systemName: "paintbrush.fill")
                                .foregroundColor(.firstColor)
                                .font(.title)
                        }
                    }
                }
                .buttonStyle(CircleButtonStyle())
                .disabled(isUnlocked)
            }
            .simultaneousGesture(
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
            )
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
                colors: [.firstColor, .white],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                Text("밀어서 시작하기")
                    .font(.subheadline)
                    .bold()
            )
            .frame(maxWidth: .infinity)
        }
    }
}

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.78 : 0.8)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.default, value: configuration.isPressed)
    }
}

#Preview {
    SlideToUnlock()
}
