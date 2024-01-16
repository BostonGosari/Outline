//
//  ScoreShimmer.swift
//  Outline
//
//  Created by hyunjun on 11/19/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func scoreShimmer(color: LinearGradient, highlight: Color, hightlightOpacity: CGFloat = 1, speed: CGFloat = 3) -> some View {
        self
            .modifier(ScoreShimmerEffect(color: color, highlight: highlight, hightlightOpacity: hightlightOpacity, speed: speed))
    }
}

struct ScoreShimmerEffect: ViewModifier {
    var color: LinearGradient
    var highlight: Color
    var blur: CGFloat = 0
    var hightlightOpacity: CGFloat
    var speed: CGFloat
    
    @State private var moveTo: CGFloat = -1.2
    
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
                                            .linearGradient(colors: [.clear, highlight.opacity(hightlightOpacity), highlight.opacity(hightlightOpacity), .clear], startPoint: .top, endPoint: .bottom)
                                        )
                                        .blur(radius: blur)
                                        .rotationEffect(.init(degrees: 110))
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                        .scaleEffect(x: 1)
                                }
                        }
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 1.2
                        }
                    }
                    .animation(.easeInOut(duration: speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

#Preview {
    Text("100")
        .fontWeight(.bold)
        .fontWidth(.expanded)
        .font(.system(size: 64))
        .scoreShimmer(color: LinearGradient(
            colors: [.customCardScoreGradient1, .customCardScoreGradient2, .customCardScoreGradient3, .customCardScoreGradient4, .customCardScoreGradient5, .customCardScoreGradient6, .customCardScoreGradient7, .customCardScoreGradient8, .customCardScoreGradient9],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        ), highlight: .white)
}
