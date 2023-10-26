//
//  SlideToUnlock.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct SlideToUnlock: View {
    
    @Binding var isUnlocked: Bool
    
    private let maxWidth: CGFloat = 320
    private let minWidth: CGFloat = 70
    @State private var width: CGFloat = 70
    
    @State private var isReached = false
    
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
                    colors: [.primaryColor, .secondaryColor],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: minWidth)
            .overlay(alignment: .trailing) {
                dragCircle
            }
            .simultaneousGesture(drag)
            .animation(.bouncy, value: width)
    }
    
    var backGround: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(.thinMaterial)
            LinearGradient(
                colors: [.secondaryColor, .white],
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
            if isReached {
                ProgressView()
                    .tint(.secondaryColor)
                    .controlSize(.large)
            } else {
                Image(systemName: "paintbrush.fill")
                    .foregroundColor(.secondaryColor)
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
                    withAnimation(.bouncy) {
                        isReached = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isUnlocked = true
                            width = minWidth
                            isReached = false
                        }
                    }
                }
            }
    }
}

#Preview {
    SlideToUnlock(isUnlocked: .constant(false))
}
