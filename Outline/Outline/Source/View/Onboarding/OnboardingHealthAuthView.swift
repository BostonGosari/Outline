//
//  OnboardingHealthAuthView.swift
//  Outline
//
//  Created by Seungui Moon on 10/23/23.
//

import SwiftUI

struct OnboardingHealthAuthView: View {
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
    }
}

#Preview {
    OnboardingHealthAuthView()
}
