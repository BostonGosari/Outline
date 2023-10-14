//
//  LocationAuthorizationView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct LocationAuthorizationView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Text("정확한 경로 정보를 제공하기 위해\n위치 허용이 필요합니다.")
                .multilineTextAlignment(.center)
                .padding(.top, 100)
                .onAppear {
                    locationManager.checkLocationAuthorization()
                }
            Spacer()
        }
    }
}

#Preview {
    LocationAuthorizationView()
}
