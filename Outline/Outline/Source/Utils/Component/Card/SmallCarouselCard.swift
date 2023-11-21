//
//  SmallCarouselCard.swift
//  Outline
//
//  Created by hyunjun on 11/19/23.
//

import SwiftUI

struct SmallCarouselCard<Content: View>: View {
    var cardType: CardType
    var runName: String
    var date: String
    @ViewBuilder var content: () -> Content
    
    private let cardWidth = UIScreen.main.bounds.width * 0.5
    private let cardHeight = UIScreen.main.bounds.width * 0.5 * 1.635
    private let borderGradient = LinearGradient(
        colors: [.pink, .purple, .blue, .green],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    private let cardBorder: CGFloat = 8
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            content() // 아무거나 넣어주세요
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: cardWidth - cardBorder * 2, height: cardHeight - cardBorder * 2)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 22, bottomTrailingRadius: 22, topTrailingRadius: 39)
                }
                .padding([.leading, .top], cardBorder)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 8) {
                        Text(runName)
                            .font(.customTitle2)
                        Text(date)
                            .font(.customTab)
                    }
                    .padding(.bottom, 24)
                }
            Image(cardType.cardFrondSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 9, bottomLeadingRadius: 0, bottomTrailingRadius: 9, topTrailingRadius: 0)
                        .frame(width: cardWidth * 0.52, height: cardHeight * 0.1)
                        .frame(width: cardWidth, height: cardHeight, alignment: .topLeading)
                }
                .overlay {
                    Image("CardLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 15)
                        .padding(.trailing, 18)
                        .padding(.vertical, 8)
                        .frame(width: cardWidth * 0.52, height: cardHeight * 0.1)
                        .frame(width: cardWidth, height: cardHeight, alignment: .topLeading)
                }
            Image(cardType.cardFrondSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 47)
                        .strokeBorder(lineWidth: cardBorder)
                }
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 47)
                }
            UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 47)
                .stroke(borderGradient, lineWidth: 1.5)
            
            Image(cardType.hologramImage)
                .resizable()
                .opacity(cardType == .excellent ? 0.2 : 0.1)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 47)
                }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

#Preview {
    SmallCarouselCard(cardType: .great, runName: "돌고래런", date: "2023.11.19") {
        Rectangle()
            .foregroundStyle(.gray)
    }
}
