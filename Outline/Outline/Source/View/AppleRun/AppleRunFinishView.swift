//
//  FinishAppleRunView.swift
//  Outline
//
//  Created by hyunjun on 12/1/23.
//

import SwiftUI

struct AppleRunFinishView: View {
    @StateObject private var appleRunManager = AppleRunManager.shared
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            Circle()
                .frame(width: 350)
                .foregroundStyle(.customPrimary.opacity(0.35))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: -175, y: -100)
                .blur(radius: 120)
            Circle()
                .frame(width: 350)
                .foregroundStyle(.customPrimary.opacity(0.35))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 100, y: 100)
                .blur(radius: 120)
            
            VStack {
                BigCard(cardType: .excellent, runName: "애플런", date: "23 Apple Developer Academy FINAL SHOWCASE", editMode: false, time: "00:20", distance: "0.1KM", pace: "0'20''", kcal: "50", bpm: "120", score: 100) { } content: {
                    Image("AppleRunCardImage")
                        .resizable()
                }
                .padding(.top, 90)

                Spacer()
                
                CompleteButton(text: "자랑하기", isActive: true) {
                    appleRunManager.running = false
                    appleRunManager.finish = false
                }
                .padding(.bottom, 16)
                
                Button(action: {
                    withAnimation {
                        appleRunManager.running = false
                        appleRunManager.finish = false
                    }
                }, label: {
                    Text("홈으로 돌아가기")
                        .underline(pattern: .solid)
                        .foregroundStyle(Color.gray300)
                        .font(.customSubbody)
                })
                .padding(.bottom, 8)
            }
        }
    }
}

#Preview {
    AppleRunFinishView()
}
