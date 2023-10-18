//
//  BottomScrollView.swift
//  Outline
//
//  Created by 김하은 on 10/16/23.
//

import SwiftUI

struct BottomScrollView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("이런 코스도 있어요.")
                .font(Font.system(size: 20).weight(.semibold))
                .foregroundColor(.white)
          
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(1...10, id: \.self) { _ in
                            Rectangle()
                                .frame(width: 164, height: 236)
                                .background(
                                    ZStack {
                                        Image("Sample")
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: .black, location: 0.00),
                                                Gradient.Stop(color: .black.opacity(0), location: 1.00)
                                            ],
                                            startPoint: UnitPoint(x: 0.5, y: 0.9),
                                            endPoint: UnitPoint(x: 0.5, y: 0)
                                        )
                                        VStack(alignment: .leading) {
                                            Spacer()
                                            Text("오리런")
                                                .font(Font.system(size: 20).weight(.semibold))
                                                .foregroundColor(.white)
                                            HStack(spacing: 0) {
                                                Image(systemName: "mappin")
                                                    .foregroundColor(.gray600)
                                                Text("서울시 동작구")
                                                    .foregroundColor(.gray600)
                                            }
                                            .font(.caption)
                                            .padding(.bottom, 16)
                                        }
                                        .frame(width: 164)
                                        .offset(x: -15)
                                        
                                    }
                                    
                                )
                                .roundedCorners(5, corners: [.topLeft])
                                .roundedCorners(30, corners: [.bottomLeft, .bottomRight, .topRight])
                                .foregroundColor(.clear)
                                .overlay(
                                    CustomRoundedRectangle(
                                          cornerRadiusTopLeft: 5,
                                          cornerRadiusTopRight: 29,
                                          cornerRadiusBottomLeft: 29,
                                          cornerRadiusBottomRight: 29
                                      )
                                    .offset(x: 1, y: 1)
                                    .frame(width: 166, height: 238)
                                )
                                
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 106)
            }
            .padding(.top, 33)
            .padding(.leading, 16)
    }
}

#Preview {
    BottomScrollView()
}
