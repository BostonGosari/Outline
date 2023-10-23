//
//  LoginView.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("loginBackground")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        
                    NavigationLink {
                        InputNicknameView()
                    } label: {
                        HStack {
                            Spacer()
                            Text("시작하기")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
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
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                        Text("또는")
                            .foregroundStyle(.white)
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    .padding(.vertical, 5)
                    Button {
                        UserDefaults.standard.set("lookAround", forKey: "authState")
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
        .onAppear {
            
        }
    }
}

extension LoginView {
    private var borderRectangle: some View {
        RoundedRectangle(cornerRadius: 60)
            .stroke(LinearGradient(colors: [Color.white, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
            .foregroundColor(.clear)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
    }
}

#Preview {
    LoginView()
}
