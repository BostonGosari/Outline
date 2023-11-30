//
//  AppleRunCard.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import SwiftUI

struct AppleRunCard: View {
    @Binding var loading: Bool
    var index: Int
    var currentIndex: Int
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.gray700)
            .mask {
                UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
            }
            .shadow(color: .white, radius: 1, y: -1)
            .frame(
                width: UIScreen.main.bounds.width * 0.84,
                height: UIScreen.main.bounds.width * 0.84 * 1.5
            )
            .overlay(alignment: .topLeading) {
                if !loading {
                    ScoreStar(score: 100, size: .big)
                        .padding(24)
                }
            }
            .overlay(alignment: .bottom) {
                if !loading {
                    courseInformation
                        .opacity(index == currentIndex ? 1 : 0)
                        .offset(y: index == currentIndex ? 0 : 10)
                        .background(alignment: .bottom) {
                            Rectangle()
                                .foregroundStyle(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .black.opacity(0), location: 0.00),
                                            Gradient.Stop(color: .black.opacity(0.7), location: 0.33),
                                            Gradient.Stop(color: .black.opacity(0.8), location: 1.00)
                                        ],
                                        startPoint: UnitPoint(x: 0.5, y: 0),
                                        endPoint: UnitPoint(x: 0.5, y: 1)
                                    )
                                )
                                .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
                                .opacity(index == currentIndex ? 1 : 0)
                        }
                }
            }
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("애플런")
                .font(.customHeadline)
                .bold()
                .padding(.bottom, 8)
                .padding(.top, 47)
            HStack {
                Image(systemName: "mappin")
                Text("애플 디벨로퍼 아카데미 • 내 위치에서 0km")
            }
            .font(.customCaption)
            .padding(.bottom, 11)
            HStack(spacing: 8) {
                Text("#0.1km")
                    .font(.customTag)
                    .foregroundColor(Color.customPrimary)
                Text("#3분대")
                    .font(.customTag)
                   
            }
            .padding(.bottom, 19)
        }
        .padding(.vertical, 24)
        .padding(.leading, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeTabView()
}
