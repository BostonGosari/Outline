//
//  OnboardingLocationAuthView.swift
//  Outline
//
//  Created by Seungui Moon on 10/23/23.
//

import CoreLocation
import SwiftUI

struct OnboardingLocationAuthView: View {
    @StateObject var locationManager = LocationManager()
    @State private var isResponsed = false

    var body: some View {
        VStack {
            Text("위치 권한을 켜주세요")
                .font(.title2)
            Text("러닝 중 현재 위치를 정확히 알 수 있어요.")
                .font(.subBody)
            Spacer()
        }
        .padding(.top, 80)
        .navigationBarBackButtonHidden()
        .onAppear {
            locationManager.requestLocation()
        }
        .navigationDestination(isPresented: $locationManager.isNext) {
            OnboardingNotificationAuthView()
        }
    }
}

#Preview {
    OnboardingLocationAuthView()
}