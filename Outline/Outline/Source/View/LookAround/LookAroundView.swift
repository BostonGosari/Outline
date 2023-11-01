//
//  LookAroundView.swift
//  Outline
//
//  Created by Seungui Moon on 11/2/23.
//

import SwiftUI

struct LookAroundView: View {
    @AppStorage("authState") var authState: AuthState = .onboarding
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Image("lookAroundImage")
                    .offset(x: 22)
                Text("앗! 회원가입이 필요해요.")
                    .font(.title2)
                    .padding(.bottom, 8)
                Text("OUTLINE에 가입하면 내가 그린\n러닝 기록을 확인할 수 있어요!")
                    .font(.subBody)
                    .padding(.bottom, 32)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray300)
                
                CompleteButton(text: "가입하러 가기", isActive: true) {
                    authState = .logout
                }
            }
            Spacer()
        }
    }
}

struct LookAroundModalView: View {
    @AppStorage("authState") var authState: AuthState = .onboarding
    var completion: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Text("앗! 회원가입이 필요해요.")
                    .font(.title2)
                    .padding(.bottom, 8)
                Text("OUTLINE에 가입하면 내가 그린\n러닝 기록을 확인할 수 있어요!")
                    .font(.subBody)
                    .padding(.bottom, 32)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray300)
                Image("lookAroundImage")
                    .offset(x: 22)
                
                CompleteButton(text: "가입하러 가기", isActive: true) {
                    authState = .logout
                }
                Button {
                    completion()
                } label: {
                    Text("계속 둘러보기")
                }
            }
            Spacer()
        }
        .presentationDetents([.height(420)])
        .presentationCornerRadius(35)
        .interactiveDismissDisabled()
    }
}

#Preview {
    LookAroundView()
}
