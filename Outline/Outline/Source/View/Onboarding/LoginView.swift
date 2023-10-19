//
//  LoginView.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            Image("loginBackground")
                .resizable()
                .frame(width: .infinity, height: .infinity)
            Image("loginLines")
            VStack(spacing: 40) {
                Image("logoOutline")
                
                    
                Button {
                    loginWithApple()
                } label: {
                    HStack {
                        Image("logoApple")
                        Text("애플아이디로 계속하기")
                            .foregroundColor(.white)
                    }
                    .overlay {
                        overlayRectangle
                    }
                }
                
                Button {
                    loginWithApple()
                } label: {
                    HStack {
                        Image("logoKakaotalk")
                        Text("카카오톡으로 계속하기")
                            .foregroundColor(.white)
                    }
                    .overlay {
                        overlayRectangle
                    }
                }
                Text("또는")
                    .foregroundStyle(.white)
                Button {
                    
                } label: {
                    Text("둘러보기")
                        .foregroundStyle(.white)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func loginWithApple() {
        
    }
}

extension LoginView {
    var overlayRectangle: some View {
        Rectangle()
        .foregroundColor(.clear)
        .frame(width: .infinity, height: 60)
        .background(.white.opacity(0.2))
        .cornerRadius(60)
        .overlay(
            RoundedRectangle(cornerRadius: 60)
            .inset(by: 0.5)
            .stroke(.white, lineWidth: 1)
        )
    }
}

#Preview {
    LoginView()
}
