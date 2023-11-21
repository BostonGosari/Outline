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
    case notification
    case photoLibrary
    
    var title: String {
        switch self {
        case .health:
            return "건강 권한 허용"
        case .location:
            return "위치 권한 설정"
        case .motion:
            return "활동 데이터 공유 활성화"
        case .notification:
            return "알림 권한 설정"
        case .photoLibrary:
            return "사진 권한 허용"
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
        case .notification:
            return "권한을 허용해 편리하게 Outline을 사용하세요."
        case .photoLibrary:
            return "권한을 허용하면 이미지를 저장할 수 있어요."
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
        case .notification:
            return "NotificationPermissionImage"
        case .photoLibrary:
            return "AlbumPermissionImage"
        }
    }
}

struct PermissionSheet: View {
    @Environment(\.dismiss) var dismiss
    var permissionType: PermissionType
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(lineWidth: 2)
                .foregroundStyle(Gradient(colors: [.customPrimary, .gray900, .gray900, .gray900]))
                .ignoresSafeArea()
            VStack(spacing: 10) {
                Text(permissionType.title)
                    .font(.customTitle2)
                    .fontWeight(.semibold)
                    .padding(.top, 36)
                Text(permissionType.subTitle)
                    .font(.customSubbody)
                    .foregroundColor(.gray300)
                    .multilineTextAlignment(.center)
                Image(permissionType.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                Button {
                    openAppSetting()
                    dismiss()
                } label: {
                    Text("설정으로 가기")
                        .font(.customButton)
                        .foregroundStyle(Color.customBlack)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color.customPrimary)
                        }
                }
                .padding()
                
                Button {
                    dismiss()
                } label: {
                    Text("닫기")
                        .font(.customBody)
                        .foregroundStyle(.customWhite)
                        .frame(maxWidth: .infinity)
                }
            }
            .presentationDetents([.height(400)])
            .presentationCornerRadius(35)
        }
    }
    
    private func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    Text("sheet")
        .sheet(isPresented: .constant(true)) {
            PermissionSheet(permissionType: .health)
        }
}
