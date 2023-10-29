//
//  SlideToUnlock.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct SlideToUnlock: View {
    
    @Binding var isUnlocked: Bool
    @Binding var progress: Double
    
    private let maxWidth: CGFloat = 320
    private let minWidth: CGFloat = 70
    @State private var width: CGFloat = 70
    
    @State private var isReached = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            background
            slideButton
        }
        .frame(width: 320, height: minWidth)
    }
    
    // MARK: - View Components
    
    var slideButton: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [width > 70 ? .primaryColor : .clear, .clear],
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
    
    var background: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(.ultraThinMaterial.opacity(0.8))
            Capsule()
                .foregroundStyle(.white.opacity(0.1))
            Capsule()
                .stroke(LinearGradient(colors: [.gray500, .gray750], startPoint: .top, endPoint: .bottom), lineWidth: 0.5)
            
            Text("밀어서 그리기")
                .font(.title3)
                .bold()
                .shimmer(color: .white20, highlight: .primaryColor)
                .frame(maxWidth: .infinity)
        }
    }
    
    var dragCircle: some View {
        ZStack {
            Circle()
                .foregroundColor(.primaryColor)
            if isReached {
                ProgressView()
                    .tint(.black)
            } else {
                Image(systemName: "paintbrush.fill")
                    .foregroundColor(.gray750)
                    .font(.system(size: 20))
            }
        }
        .scaleEffect(0.85)
    }
    
    // MARK: - Drag Gesture
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.width >= 0 {
                    width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                    
                    let range = maxWidth - minWidth
                    progress = Double(width - minWidth) / Double(range)
                }
            }
            .onEnded { _ in
                guard !isUnlocked else { return }
                if width < maxWidth {
                    width = minWidth
                    progress = 0
                } else {
                    withAnimation {
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
    SlideToUnlock(isUnlocked: .constant(false), progress: .constant(0.0))
}
