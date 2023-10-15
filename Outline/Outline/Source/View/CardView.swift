//
//  CardView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CardView: View {
    
    let cardWidth: CGFloat = 318
    let cardHeight: CGFloat = 484
    
    var body: some View {
        Button {
            
        } label: {
            Rectangle()
                .frame(width: cardWidth, height: cardHeight)
                .foregroundStyle(.thinMaterial)
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("시티런")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 8)
                        HStack {
                            Image(systemName: "mappin")
                            Text("서울시 동작구 • 내 위치에서 5km")
                        }
                        .font(.caption)
                        .padding(.bottom, 16)
                        HStack {
                            Text("#5km")
                                .frame(width: 70, height: 23)
                                .background {
                                    Capsule()
                                        .stroke()
                                }
                            Text("#2h39m")
                                .frame(width: 70, height: 23)
                                .background {
                                    Capsule()
                                        .stroke()
                                }
                        }
                        .font(.caption)
                    }
                    .padding(.horizontal, 17)
                    .padding(.bottom, 36)
                }
                .roundedCorners(10, corners: [.topLeft])
                .roundedCorners(70, corners: [.topRight])
                .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
                .shadow(color: .white, radius: 1, y: -0.5)
        }
        .buttonStyle(CardButtonStyle())
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

#Preview {
    CardView()
}
