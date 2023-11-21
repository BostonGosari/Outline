//
//  Shimmer.swift
//  Outline
//
//  Created by hyunjun on 10/29/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func shimmer(color: Color, highlight: Color, hightlightOpacity: CGFloat = 1, speed: CGFloat = 3) -> some View {
        self
            .modifier(ShimmerEffect(color: color, highlight: highlight, hightlightOpacity: hightlightOpacity, speed: speed))
    }
}

struct ShimmerEffect: ViewModifier {
    var color: Color
    var highlight: Color
    var blur: CGFloat = 0
    var hightlightOpacity: CGFloat
    var speed: CGFloat
    
    @State private var moveTo: CGFloat = -0.6
    
    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(color)
                    .mask {
                        content
                    }
                    .overlay {
                        GeometryReader {
                            let size = $0.size
                            let extraOffset = size.height / 2
                            
                            Rectangle()
                                .fill(highlight)
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(colors: [ highlight.opacity(hightlightOpacity), .clear], startPoint: .top, endPoint: .bottom)
                                        )
                                        .blur(radius: blur)
                                        .rotationEffect(.init(degrees: 95))
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                        .scaleEffect(x: 2)
                                }
                        }
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.6
                        }
                    }
                    .animation(.easeInOut(duration: speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

#Preview {
    SlideToUnlock(isUnlocked: .constant(false), progress: .constant(0.0))
}
