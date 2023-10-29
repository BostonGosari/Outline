//
//  LoginView.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.window) var window: UIWindow?

    @StateObject private var firebaseAuthViewModel = FirebaseAuthViewModel()
    
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
                        
                    Button {
                        firebaseAuthViewModel.handleAppleLogin(window: window)
                    } label: {
                        HStack {
                            Spacer()
                            Image("logoApple")
                                .resizable()
                                .frame(width: 24, height: 29)
                                .scaledToFit()
                                .padding(.trailing, 37)
                            Text("애플아이디로 계속하기")
                                .foregroundColor(.white)
                                .frame(height: 60)
                            Spacer()
                        }
                        .background(.ultraThinMaterial.opacity(0.9))
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
