//
//  SmallCarouselCard.swift
//  Outline
//
//  Created by hyunjun on 11/19/23.
//

import CoreLocation
import SwiftUI

struct SmallCarouselCard: View {
   
    private let cardWidth = UIScreen.main.bounds.width * 0.5
    private let cardHeight = UIScreen.main.bounds.width * 0.5 * 1.635
    private let cardBorder: CGFloat = 8
    private let borderGradient = LinearGradient(
        colors: [.pink, .purple, .blue, .green],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
   
    var cardType: CardType
    var runName: String
    var date: String
    var data: [CLLocationCoordinate2D]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("sampleMapImage")
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: cardWidth - cardBorder * 2, height: cardHeight - cardBorder * 2)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 22, bottomTrailingRadius: 22, topTrailingRadius: 39)
                }
                .padding([.leading, .top], cardBorder)
               
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
                .opacity(cardType == .excellent ? 0.7 : 0.5)
                .blendMode(.overlay)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 47)
                }
                .overlay(alignment: .bottom) {
                    VStack(spacing: 6) {
                        PathGenerateManager
                            .caculateLines(width: 200, height: 200, coordinates: data)
                            .scale(0.5)
                            .stroke(.customPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                            .padding(.horizontal, 16)
                        Text(runName)
                            .font(.customTitle2)
                        Text(date)
                            .font(.customCaption)
                    }
                    .padding(.bottom, 24)
                    .foregroundStyle(.customWhite)
                }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

struct SmallCarouselEmptyCard: View {
    private let cardWidth = UIScreen.main.bounds.width * 0.5
    private let cardHeight = UIScreen.main.bounds.width * 0.5 * 1.635
    
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 47)
            .fill(.white7)
            .stroke(.white30, lineWidth: 1.0)
            .frame(width: cardWidth, height: cardHeight)
    }
}

#Preview {
    SmallCarouselCard(cardType: .excellent, runName: "돌고래런", date: "2023.12.12", data: [])
}
