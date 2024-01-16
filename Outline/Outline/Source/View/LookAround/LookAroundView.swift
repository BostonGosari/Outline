//
//  LookAroundView.swift
//  Outline
//
//  Created by Seungui Moon on 11/2/23.
//

import SwiftUI

struct LookAroundView: View {
    @AppStorage("authState") var authState: AuthState = .logout
    var type: LookArroundType
    
    var body: some View {
        VStack {
            Image("lookAroundImage")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .scaleEffect(1.6)
                .padding(.leading, 40)
                .offset(y: 10)
                .padding(.bottom, 16)
            Text("앗! 회원가입이 필요해요.")
                .font(.customTitle2)
                .padding(.bottom, 8)
            Text(type.subTitle)
                .font(.customSubbody)
                .padding(.bottom, 32)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray300)
            CompleteButton(text: "가입하러 가기", isActive: true) {
                authState = .logout
            }
            .padding(.horizontal, 14)            
        }
        .padding(.bottom, 100)
    }
}

struct LookAroundPopupView: View {
    @AppStorage("authState") var authState: AuthState = .logout
    
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(Color.black70)
            .strokeBorder(Color.customPrimary)
            .frame(height: 54)
            .padding(.horizontal, 24)
            .overlay {
                HStack {
                    Text("OUTLINE 둘러보는 중")
                        .foregroundStyle(Color.white)
                        .font(.customSubbody)
                    Spacer()
                    Group {
                        Text("회원가입")
                            .foregroundStyle(Color.white)
                            .font(.customSubbody)
                        Image(systemName: "arrow.right.circle")
                            .foregroundStyle(Color.customPrimary)
                    }
                    .onTapGesture {
                        authState = .logout
                    }
                }
                .frame(height: 54)
                .padding(.horizontal, 44)
            }
    }
}

#Preview {
    LookAroundView(type: .running)
}
