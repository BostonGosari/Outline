//
//  PermissionSheet.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

enum PermissionType: String {
    case location = "위치"
    case health = "건강"
}

struct PermissionSheet: View {
    var type: PermissionType = .location
    
    var systemImageName: String {
        switch type {
        case .location:
            "location.circle"
        case .health:
            "heart.circle"
        }
    }
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: systemImageName)
                .font(.system(size: 36))
                .foregroundStyle(.customPrimary)
                .padding(.bottom, 2)
            Text("OUTLINE iPhone을 실행해서\n\(type.rawValue) 권한을 허용해주세요.")
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
