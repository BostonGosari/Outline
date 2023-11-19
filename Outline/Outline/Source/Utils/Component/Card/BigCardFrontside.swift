//
//  BigCard.swift
//  Outline
//
//  Created by hyunjun on 11/18/23.
//

import SwiftUI
import MapKit

struct BigCardFrontside: View {
    private let cardWidth = UIScreen.main.bounds.width * 0.815
    private let cardHeight = UIScreen.main.bounds.width * 0.815 * 1.635
    private let cardBorder: CGFloat = 10
    
    var cardType: CardType
    var runName: String
    var date: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle() // 아무거나 넣어주세요
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: cardWidth - 20, height: cardHeight - 20)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 35, bottomTrailingRadius: 35, topTrailingRadius: 60)
                }
                .padding([.leading, .top], 10)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 8) {
                        Text(runName)
                            .font(.customHeadline)
                        Text(date)
                            .font(.customSubbody)
                    }
                    .padding(.bottom, 36)
                }
            Image(cardType.cardFrondSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 14, topTrailingRadius: 0)
                        .frame(width: cardWidth * 0.52, height: cardHeight * 0.1)
                        .frame(width: cardWidth, height: cardHeight, alignment: .topLeading)
                }
                .overlay {
                    Image("CardLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 25)
                        .padding(.trailing, 30)
                        .padding(.vertical, 12)
                        .frame(width: cardWidth * 0.52, height: cardHeight * 0.1)
                        .frame(width: cardWidth, height: cardHeight, alignment: .topLeading)
                }
            Image(cardType.cardFrondSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                        .strokeBorder(lineWidth: 10)
                }
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

#Preview {
    BigCardFrontside(cardType: .good, runName: "돌고래런", date: "2023.11.19")
}
