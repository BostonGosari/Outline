//
//  SmallListCard.swift
//  Outline
//
//  Created by hyunjun on 11/19/23.
//

import CoreLocation
import SwiftUI

struct SmallListCard: View {
    var cardType: CardType
    var runName: String
    var date: String
    var data: [CLLocationCoordinate2D]
    
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
            Image("sampleMapImage")
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: cardWidth - cardBorder * 2, height: cardHeight - cardBorder * 2)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 1, bottomLeadingRadius: 11, bottomTrailingRadius: 11, topTrailingRadius: 21)
                }
                .padding([.leading, .top], cardBorder)
                
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
                .opacity(cardType == .excellent ? 0.5 : cardType == .great ? 0.5 : 0.2)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 25)
                }
                .overlay(alignment: .bottom) {
                    VStack(spacing: 2) {
                        PathGenerateManager
                            .caculateLines(width: 100, height: 100, coordinates: data)
                            .scale(0.5)
                            .stroke(.customPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                            .padding(.horizontal, 16)
                        Text(runName)
                            .font(.customCaption)
                        Text(date)
                            .font(.customTab)
                    }
                    .foregroundStyle(.customWhite)
                    .padding(.bottom, 12)
                }
            
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

struct SmallListEmptyCard: View {
    private let cardWidth = UIScreen.main.bounds.width * 0.28
    private let cardHeight = UIScreen.main.bounds.width * 0.28 * 1.65
    
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 25)
            .fill(.white7)
            .stroke(.white30, lineWidth: 1.0)
            .frame(width: cardWidth, height: cardHeight)
    }
}

//#Preview {
//    HStack {
//        SmallListCard(cardType: .nice, runName: "돌고래런", date: "2023/10/23") {
//            ZStack {
//                Rectangle()
//                    .foregroundStyle(.black)
//                Text("안녕")
//                    .font(.customTitle)
//                    .foregroundStyle(.customWhite)
//            }
//           
//        }
//        SmallListCard(cardType: .great, runName: "돌고래런", date: "2023/10/23") {
//            ZStack {
//                Rectangle()
//                    .foregroundStyle(.black)
//                Text("안녕")
//                    .font(.customTitle)
//                    .foregroundStyle(.customWhite)
//            }
//        }
//        SmallListCard(cardType: .excellent, runName: "돌고래런", date: "2023/10/23") {
//            ZStack {
//                Rectangle()
//                    .foregroundStyle(.black)
//                Text("안녕")
//                    .font(.customTitle)
//                    .foregroundStyle(.customWhite)
//            }
//        }
//    }
//   
//}
