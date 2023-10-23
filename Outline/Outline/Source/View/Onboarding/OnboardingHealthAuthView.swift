//
//  OnboardingHealthAuthView.swift
//  Outline
//
//  Created by Seungui Moon on 10/23/23.
//

import SwiftUI

struct OnboardingHealthAuthView: View {
    
    @State private var showHealthAuthentication = true

    var body: some View {
        ZStack {
            VStack {
                Image("AuthHealth")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                Text("APPLE 건강")
                    .font(.title2)
                Spacer()
                    .frame(height: 300)
                
                Text("건강앱의 기록으로\n정확한 러닝 정보를 얻을 수 있어요!")
                    .multilineTextAlignment(.center)
            }
            .navigationBarBackButtonHidden(true)
        }
        .alert(isPresented: $showHealthAuthentication) {
            Alert(
                title: Text("알림"),
                message: Text("APPLE 건강앱을 동기화하면,\n앱 이외의 활동 및 건강을\n추적할 수 있습니다."),
                primaryButton: .default(Text("취소"), action: {
                    // cancel reaction
                }), secondaryButton: .default(Text("확인"), action: {
                    // authentication
                }))
        }
    }
}

#Preview {
    OnboardingHealthAuthView()
}
