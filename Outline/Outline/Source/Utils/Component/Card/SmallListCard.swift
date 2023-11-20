//
//  SmallListCard.swift
//  Outline
//
//  Created by hyunjun on 11/19/23.
//

import SwiftUI

struct SmallListCard<Content: View>: View {
    var cardType: CardType
    var runName: String
    @ViewBuilder var content: () -> Content
    
    private let cardWidth = UIScreen.main.bounds.width * 0.28
    private let cardHeight = UIScreen.main.bounds.width * 0.28 * 1.65
    private let borderGradient = LinearGradient(
        colors: [.pink, .purple, .blue, .green],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    private let cardBorder: CGFloat = 4
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            content()
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: cardWidth - cardBorder * 2, height: cardHeight - cardBorder * 2)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 1, bottomLeadingRadius: 11, bottomTrailingRadius: 11, topTrailingRadius: 21)
                }
                .padding([.leading, .top], cardBorder)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 8) {
                        Text(runName)
                            .font(.customTag2)
                    }
                    .padding(.bottom, 16)
                }
            Image(cardType.cardFrondSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 0, bottomTrailingRadius: 5, topTrailingRadius: 0)
                        .frame(width: cardWidth * 0.52, height: cardHeight * 0.1)
                        .frame(width: cardWidth, height: cardHeight, alignment: .topLeading)
                }
                .overlay {
                    Image("CardLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 8)
                        .padding(.trailing, 10)
                        .padding(.vertical, 3)
                        .frame(width: cardWidth * 0.52, height: cardHeight * 0.1)
                        .frame(width: cardWidth, height: cardHeight, alignment: .topLeading)
                }
            Image(cardType.cardFrondSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 25)
                        .strokeBorder(lineWidth: cardBorder)
                }
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 25)
                }
            UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 25)
                .stroke(borderGradient, lineWidth: 1)
            
            Image(cardType.hologramImage)
                .resizable()
                .opacity(cardType == .excellent ? 0.2 : 0.1)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 25)
                }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

#Preview {
    SmallListCard(cardType: .nice, runName: "돌고래런") {
        Rectangle()
            .foregroundStyle(.black)
    }
}
