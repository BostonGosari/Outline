//
//  FirstRunningGuideView.swift
//  Outline
//
//  Created by Hyunjun Kim on 11/1/23.
//

import SwiftUI

struct FirstRunningGuideView: View {
    @Binding var isFirstRunning: Bool
    
    var body: some View {
        ZStack {
            Color.customBlack
                .opacity(0.7)
                .overlay(.ultraThinMaterial.opacity(0.3))
            
            VStack(spacing: 0) {
                Text("첫 그림이네요!\n우리 같이 완성해봐요")
                    .font(.firstGuideTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 24)
                    .padding(.bottom, 56)
                
                Group {
                    Text("회색 라인")
                        .foregroundStyle(.customPrimary)
                    + Text("을 따라가면\n그림이 그려져요")
                }
                .font(.subBody)
                .padding(.bottom, 16)
                
                Image("FirstRunningIcon1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .padding(.bottom, 36)
                
                Group {
                    Text("버튼을 눌러 ")
                    + Text("현재 위치")
                        .foregroundStyle(.customPrimary)
                    + Text("와\n")
                    + Text("러닝데이터")
                        .foregroundStyle(.customPrimary)
                    + Text("를 볼 수 있어요")
                }
                .font(.tag)
                .padding(.bottom, 16)
                
                Image("FirstRunningIcon2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 62)
                    .padding(.bottom, 103)
                
                Button {
                    isFirstRunning = false
                } label: {
                    Text("러닝 시작하기")
                        .font(.button)
                        .foregroundStyle(.customBlack)
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.customPrimary)
                        }
                }
                .buttonStyle(TabButtonStyle())
                .padding(.horizontal, 43)
            }
            .multilineTextAlignment(.center)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    FirstRunningGuideView(isFirstRunning: .constant(true))
}
