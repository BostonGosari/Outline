//
//  BigCardBackSide.swift
//  Outline
//
//  Created by hyunjun on 11/18/23.
//

import SwiftUI

struct BigCardBackSide: View {
    private let cardWidth = UIScreen.main.bounds.width * 0.815
    private let cardHeight = UIScreen.main.bounds.width * 0.815 * 1.635
    private let borderGradient = LinearGradient(
        colors: [.pink, .purple, .blue, .green],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var cardType: CardType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(cardType.cardBackSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                }
            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                .stroke(borderGradient, lineWidth: 2)
            Image(cardType.hologramImage)
                .resizable()
                .opacity(cardType == .excellent ? 0.4 : 0.2)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

#Preview {
    BigCardBackSide(cardType: .excellent)
}
