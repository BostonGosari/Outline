//
//  CardAnimationForShowcase.swift
//  Outline
//
//  Created by hyunjun on 12/3/23.
//

import SwiftUI

struct CardAnimationForShowcase: View {
    @State private var showPopup = false
    
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
                BigCard(cardType: .excellent, runName: "고래런", date: "2023.12.04", editMode: false, time: "62:30", distance: "6.2KM", pace: "5'30''", kcal: "520", bpm: "120", score: 100) {
                    
                } content: {
                    Image("dolphineRun")
                        .resizable()
                }
                .padding(.top, 90)
                Spacer()
                CompleteButton(text: "자랑하기", isActive: true) {
                }
                .padding(.bottom, 16)
                
                Button(action: {

                }, label: {
                    Text("홈으로 돌아가기")
                        .underline(pattern: .solid)
                        .foregroundStyle(Color.gray300)
                        .font(.customSubbody)
                })
                .padding(.bottom, 8)
            }

        }
        .overlay {
            if showPopup {
                RunningPopup(text: "기록이 저장되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .transition(.move(edge: .top))
            }
        }
        .onAppear {
            withAnimation {
                showPopup = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showPopup = false
                }
            }
        }
    }
}

#Preview {
    CardAnimationForShowcase()
}
