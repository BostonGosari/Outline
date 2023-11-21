//
//  PermissionSheet.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

enum PermissionType {
    case location
    case health
    case network
    
    var imageName: String {
        switch self {
        case .location:
            "location.circle"
        case .health:
            "heart.circle"
        case .network:
            "exclamationmark.circle"
        }
    }
    
    var title: String {
        switch self {
        case .location:
            "OUTLINE iPhone을 실행해서\n위치 권한을 허용해주세요."
        case .health:
            "OUTLINE iPhone을 실행해서\n건강 권한을 허용해주세요."
        case .network:
            "GPS 네트워크를\n불러올 수 없습니다."
        }
    }
}

struct PermissionSheet: View {
    @Environment(\.dismiss) var dismiss
    var type: PermissionType = .location
    
    var body: some View {
        VStack {
            Image(systemName: type.imageName)
                .font(.system(size: 36))
                .foregroundStyle(.customPrimary)
                .padding(.bottom, 2)
            Text(type.title)
                .multilineTextAlignment(.center)
                .font(.customBody)
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("확인")
                    .font(.customButton)
                    .foregroundStyle(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundStyle(.gray800)
                    )
            }
            .buttonStyle(.plain)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    PermissionSheet()
}
