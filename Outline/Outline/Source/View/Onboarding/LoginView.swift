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
                .ignoresSafeArea()
            VStack {
                Image("loginLines")
                Spacer()
            }
            VStack(spacing: 16) {
                Spacer()
                Image("logoOutline")
                    .padding(.top, 60)
                ZStack {
                    Rectangle()
                        .fill(.black.opacity(0.3))
                        .frame(width: 300, height: 80)
                        .blur(radius: 10, opaque: false)
                    Text("발걸음으로 나만의 유니크한 \n그림을 그려봐요.")
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.top, 0)

                Spacer()
                    
                Button
                {
                    loginWithApple()
                } label: {
                    HStack {
                        Spacer()
                        Image("logoApple")
                            .padding(.trailing, 36)
                        Text("애플아이디로 계속하기")
                            .foregroundColor(.white)
                            .frame(width: .infinity, height: 60)
                        Spacer()
                    }
                    .overlay {
                        overlayRectangle
                    }
                }
                
                Button {
                    loginWithApple()
                } label: {
                    HStack {
                        Spacer()
                        Image("logoKakaotalk")
                            .padding(.trailing, 36)
                        Text("카카오톡으로 계속하기")
                            .foregroundColor(.white)
                            .frame(width: .infinity, height: 60)
                        Spacer()
                    }
                    .overlay {
                        overlayRectangle
                    }
                }
                HStack {
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: .infinity, height: 1)
                    Text("또는")
                        .foregroundStyle(.white)
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: .infinity, height: 1)
                }
                .padding(.vertical, 5)
                Button {
                    
                } label: {
                    Text("둘러보기")
                        .foregroundStyle(.white)
                        .font(.subtitle2)
                        .fontWeight(.medium)
                }
            }
        }
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
