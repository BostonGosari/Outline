//
//  FreeRunningHomeView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct FreeRunningHomeView: View {
    @StateObject private var viewModel = FreeRunningViewModel()
   
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.authState == .login {
                FreeRunningMapView()
                    .ignoresSafeArea()
                Color.gray800.opacity(0.8)
                    .ignoresSafeArea()
                    .blendMode(.multiply)
            }

            VStack(spacing: 0) {
                Header(title: "자유 아트", loading: false, scrollOffset: 20)
                    .padding(.top, 8)
                
                if viewModel.authState == .login {
                    freerunInfoView
                } else {
                    Spacer()
                    LookAroundView(type: .running)
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

extension FreeRunningHomeView {
    @ViewBuilder
    var freerunInfoView: some View {
        Spacer()
        ZStack {
            roundedRectable
            VStack(alignment: .leading, spacing: 0) {
                Text("새로운 러닝 \(viewModel.freeRunCount == 0 ? "" : String(viewModel.freeRunCount + 1))")
                    .font(.customHeadline)
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text(viewModel.userLocation)
                }
                .font(.customCaption)
                .frame(height: 16)
                SlideToUnlock(isUnlocked: $viewModel.isUnlocked, progress: $viewModel.progress)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding(EdgeInsets(top: 58, leading: 24, bottom: 24, trailing: 16))
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 80, trailing: 20))
    }

    private var roundedRectable: some View {
        UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
            .fill(.white5)
            .stroke(.white30)
    }
}

#Preview {
    FreeRunningHomeView()
}
