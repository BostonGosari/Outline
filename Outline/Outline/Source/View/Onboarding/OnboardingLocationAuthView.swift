//
//  OnboardingLocationAuthView.swift
//  Outline
//
//  Created by Seungui Moon on 10/23/23.
//

import CoreLocation
import SwiftUI

struct OnboardingLocationAuthView: View {
    private let locationManager = CLLocationManager()
    
    @State private var isResponsed = false

    var body: some View {
        VStack {
            Text("위치 권한을 켜주세요")
                .font(.title2)
            Text("러닝 중 현재 위치를 정확히 알 수 있어요.")
                .font(.subBody)
            Spacer()
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    OnboardingNotificationAuthView()
                } label: {
                    Text("다음")
                }

            }
        }
    }
}

#Preview {
    OnboardingLocationAuthView()
}
