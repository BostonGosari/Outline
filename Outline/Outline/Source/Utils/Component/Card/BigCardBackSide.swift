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
    private let scoreGradient = LinearGradient(
        colors: [.customCardScoreGradient1, .customCardScoreGradient2, .customCardScoreGradient3, .customCardScoreGradient4, .customCardScoreGradient5, .customCardScoreGradient6, .customCardScoreGradient7, .customCardScoreGradient8, .customCardScoreGradient9],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    
    var cardType: CardType
    var runName: String
    var date: String
    var editMode: Bool
    var time: String
    var distance: String
    var pace: String
    var kcal: String
    var bpm: String
    var score: Int
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(cardType.cardBackSideImage)
                .resizable()
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
                }
                .overlay(alignment: .bottom) {
                    VStack(spacing: 8) {
                        HStack {
                            Text(runName)
                                .font(.customHeadline)
                            if cardType == .freeRun || editMode {
                                Button {
                                    // edit action
                                } label: {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 20))
                                        .fontWeight(.black)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .padding(.leading, cardType == .freeRun || editMode ? 24 : 0)
                        Text(date)
                            .font(.customSubbody)
                    }
                    .shadow(color: .black.opacity(5), radius: 4)
                    .scaleEffect(x: -1)
                    .padding(.bottom, 46)
                }
            
            if cardType == .freeRun {
                VStack(alignment: .trailing, spacing: 0) {
                    VStack(alignment: .trailing, spacing: -5) {
                        Text("TIME")
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                        Text(time)
                            .font(.customCardBody)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.white30)
                    VStack(alignment: .trailing, spacing: -5) {
                        Text("DIS")
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                        Text(distance)
                            .font(.customCardBody)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.white30)
                    VStack(alignment: .trailing, spacing: -5) {
                        Text("PACE")
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                        Text(pace)
                            .font(.customCardBody)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.white30)
                    VStack(alignment: .trailing, spacing: -5) {
                        Text("KCAL")
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                        Text(kcal)
                            .font(.customCardBody)
                    }
                    
                    if bpm != "0" {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.white30)
                        VStack(alignment: .trailing, spacing: -5) {
                            Text("BPM")
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                            Text(bpm)
                                .font(.customCardBody)
                        }
                    }
                }
                .shadow(color: .black.opacity(5), radius: 4)
                .font(.system(size: 32))
                .scaleEffect(x: -1)
                .padding(34)
            } else {
                VStack {
                    HStack(spacing: 24) {
                        VStack(alignment: .trailing) {
                            Text("TIME")
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                            Text(time)
                                .font(.customCardBody2)
                            Text("DIS")
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                            Text(distance)
                                .font(.customCardBody2)
                        }
                        Rectangle()
                            .frame(width: 1, height: 130)
                        VStack(alignment: .leading) {
                            Text("PACE")
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                            Text(pace)
                                .font(.customCardBody2)
                            Text("KCAL")
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                            Text(kcal)
                                .font(.customCardBody2)
                        }
                    }
                    .shadow(color: .black.opacity(5), radius: 4)
                    .font(.system(size: 24))
                    .padding(.top, 48)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing, 8)
                    .padding(.bottom, 80)
                    
                    VStack {
                        Text("SCORE")
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                            .font(.system(size: 36))
                        Text("\(score)")
                            .fontWeight(.bold)
                            .fontWidth(.expanded)
                            .font(.system(size: 64))
                            .scoreShimmer(color: scoreGradient, highlight: .white)
                    }
                    .shadow(color: .black.opacity(5), radius: 4)
                }
                .scaleEffect(x: -1)
            }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

#Preview {
    BigCardBackSide(cardType: .excellent, runName: "오리런", date: "2023.11.19", editMode: true, time: "00:00.00", distance: "1.2KM", pace: "9'99''", kcal: "235", bpm: "100", score: 100)
}
