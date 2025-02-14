//
//  LoginView.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import SwiftUI

struct IntroView: View {
    @Environment(\.window) var window: UIWindow?
    @StateObject private var viewModel = IntroViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Login")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack(spacing: 16) {
                    Spacer()
                        
                    Button {
                        viewModel.loginWithApple(window: window)
                    } label: {
                        HStack {
                            Spacer()
                                .frame(width: 60)
                            Image("logoApple")
                                .resizable()
                                .frame(width: 24, height: 29)
                                .scaledToFit()
                                .padding(.trailing, 37)
                            Text("애플아이디로 계속하기")
                                .font(.customSubbody)
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
                    Button {
                        viewModel.loginWithKakao()
                    } label: {
                        HStack {
                            Spacer()
                                .frame(width: 60)
                            Image("logoKakaotalk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 29)
                                .padding(.trailing, 37)
                            Text("카카오아이디로 계속하기")
                                .font(.customSubbody)
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
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundStyle(Color.gray300)
                        Text("또는")
                            .foregroundStyle(Color.gray300)
                            .font(.customCaption)
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundStyle(Color.gray300)
                    }
                    .padding(.vertical, 5)
                    Button {
                        viewModel.authState = .lookAround
                    } label: {
                        Text("둘러보기")
                            .foregroundStyle(.white)
                            .font(.customButton)
                            .fontWeight(.medium)
                    }
                    .padding(.bottom, getSafeArea().bottom == 0 ? 100 : 40)
                }
                .padding(16)
            }
        }
    }
}

extension IntroView {
    private var borderRectangle: some View {
        RoundedRectangle(cornerRadius: 60)
            .stroke(LinearGradient(colors: [Color.white, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
            .foregroundColor(.clear)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
    }
}

#Preview {
    IntroView()
}
