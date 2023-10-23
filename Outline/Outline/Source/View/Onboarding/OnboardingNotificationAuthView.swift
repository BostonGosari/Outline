//
//  OnboardingNotificationAuthView.swift
//  Outline
//
//  Created by Seungui Moon on 10/23/23.
//

import SwiftUI

struct OnboardingNotificationAuthView: View {
    @State private var showNotificationAlert = true
    var body: some View {
        VStack {
            Text("알림을 켜주세요")
                .font(.title2)
            Text("Outline 알림을 통해 러닝 현황을 확인할 수 있어요.")
                .font(.subBody)
            Spacer()
        }
        .alert(isPresented: $showNotificationAlert, content: {
            Alert(
                title: Text("‘OUTLINE’에서 알림을\n보내고자합니다."),
                message: Text("경고, 사운드 및 아이콘 배지가 알림에 포함될 수 있습니다."),
                primaryButton: .default(Text("취소"), action: {
                    // cancel reaction
                }), secondaryButton: .default(Text("허용"), action: {
                    // authentication
                }))
        })
    }
}

#Preview {
    OnboardingNotificationAuthView()
}
