//
//  OnboardingHealthAuthView.swift
//  Outline
//
//  Created by Seungui Moon on 10/23/23.
//

import SwiftUI

struct HealthAuthView: View {
    @StateObject private var viewModel = HealthAuthViewModel()
    @StateObject var inputNickNameViewModel = InputNicknameViewModel()
    @State private var showHealthAuthentication = true
    
    var body: some View {
        ZStack {
            VStack {
                Image("HealthPermissionImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                Text("APPLE 건강")
                    .font(.customTitle2)
                    .padding(.bottom, 229)
                
                Text("건강앱의 기록으로\n정확한 러닝 정보를 얻을 수 있어요!")
                    .font(.customSubbody)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 100)
            .navigationBarBackButtonHidden(true)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .alert(isPresented: $showHealthAuthentication) {
            Alert(
                title: Text("알림"),
                message: Text("APPLE 건강앱을 동기화하면,\n앱 이외의 활동 및 건강을\n추적할 수 있습니다."),
                primaryButton: .default(Text("취소"), action: {
                    viewModel.moveToInputUserInfoView = true
                }), secondaryButton: .default(Text("확인"), action: {
                    viewModel.requestHealthAuthorization()
                }))
        }
        .preferredColorScheme(.dark)
        .navigationDestination(isPresented: $viewModel.moveToInputUserInfoView) {
            InputUserInfoView(userNickName: inputNickNameViewModel.nickname)
        }
    }
}

#Preview {
    HealthAuthView()
}
