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
                    .padding(.top, 70)
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
                    
                Button {
                    // Navigate to onboarding view
                } label: {
                    HStack {
                        Spacer()
                        Text("시작하기")
                            .foregroundColor(.white)
                            .frame(width: .infinity, height: 60)
                        Spacer()
                    }
                    .background(.ultraThinMaterial.opacity(0.7))
                    .cornerRadius(60)
                    .overlay {
                        borderRectangle
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
                    // Navigate to Main
                } label: {
                    Text("둘러보기")
                        .foregroundStyle(.white)
                        .font(.subtitle2)
                        .fontWeight(.medium)
                }
            }
            .padding(16)
        }
    }
}

extension LoginView {
    private var borderRectangle: some View {
        RoundedRectangle(cornerRadius: 60)
            .stroke(LinearGradient(colors: [Color.white, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
            .foregroundColor(.clear)
            .frame(width: .infinity, height: 60)
    }
}

#Preview {
    LoginView()
}
