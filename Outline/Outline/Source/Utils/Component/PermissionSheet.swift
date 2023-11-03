//
//  PermissionSheetView.swift
//  Outline
//
//  Created by 김현준 on 11/3/23.
//

import SwiftUI

enum PermissionType {
    case health
    case location
    case motion
    
    var title: String {
        switch self {
        case .health:
            return "건강 권한 허용"
        case .location:
            return "위치 권한 설정"
        case .motion:
            return "활동 데이터 공유 활성화"
        }
    }
    
    var subTitle: String {
        switch self {
        case .health:
            return "권한을 허용하면 정확한 러닝 정보를 확인할 수 있어요."
        case .location:
            return "권한을 허용해 편리하게 Outline 사용하세요.\n위치 정보는 앱이 실행 중일때만 사용합니다."
        case .motion:
            return "권한을 허용해 편리하게 Outline을 사용하세요."
        }
    }
    
    var imageName: String {
        switch self {
        case .health:
            return "HealthPermissionImage"
        case .location:
            return "LocationPermissionImage"
        case .motion:
            return "MotionPermissionImage"
        }
    }
}

struct PermissionSheet: View {
    @Binding var showPermissionSheet: Bool
    var permissionType: PermissionType
    
    var body: some View {
        if showPermissionSheet {
            Color.black.opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        showPermissionSheet = false
                    }
                }
                .ignoresSafeArea()
        }
        VStack(spacing: 10) {
            Text(permissionType.title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            Text(permissionType.subTitle)
                .font(.subBody)
                .foregroundColor(.gray300)
                .multilineTextAlignment(.center)
            Image(permissionType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120)
            Button {
                withAnimation {
                    openAppSetting()
                    showPermissionSheet = false
                }
            } label: {
                Text("설정으로 가기")
                    .font(.button)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.customBlack)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .foregroundStyle(Color.customPrimary)
                    }
            }
            .padding()
            
            Button {
                withAnimation {
                    showPermissionSheet = false
                }
            } label: {
                Text("닫기")
                    .font(.button)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .frame(height: UIScreen.main.bounds.height / 2)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.customPrimary, lineWidth: 2)
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(Color.gray900)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .offset(y: showPermissionSheet ? 0 : UIScreen.main.bounds.height / 2 + 2)
        .animation(.easeInOut, value: showPermissionSheet)
        .ignoresSafeArea()
    }
    
    private func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
