//
//  NeedLoginSheet.swift
//  Outline
//
//  Created by hyunjun on 11/17/23.
//

import SwiftUI

enum LookArroundType {
    case userInfo
    case running
    case record
    
    var subTitle: String {
        switch self {
        case .userInfo:
            "OUTLINE에 가입하면 나의 러닝\n프로필을 입력할 수 있어요!"
        case .running:
            "OUTLINE에 가입하면 그림을 뛸 수 있어요!"
        case .record:
            "OUTLINE에 가입하면 내가 그린\n러닝 기록을 확인할 수 있어요!"
        }
    }
}

struct NeedLoginSheet: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("authState") var authState: AuthState = .logout
    
    var type: LookArroundType
    var lookArroundAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(lineWidth: 2)
                .foregroundStyle(Gradient(colors: [.customPrimary, .gray900, .gray900, .gray900]))
                .ignoresSafeArea()
            VStack(spacing: 10) {
                Text("앗 회원가입이 필요해요")
                    .font(.customTitle2)
                    .fontWeight(.semibold)
                    .padding(.top, 36)
                Text(type.subTitle)
                    .font(.customSubbody)
                    .foregroundColor(.gray300)
                    .multilineTextAlignment(.center)
                Image("lookAroundImage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .scaleEffect(1.6)
                    .padding(.leading, 40)
                    .offset(y: 10)
                Button {
                    dismiss()
                    authState = .logout
                } label: {
                    Text("가입하러 가기")
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
                    lookArroundAction()
                } label: {
                    Text("계속 둘러보기")
                        .font(.customBody)
                        .foregroundStyle(.customWhite)
                        .frame(maxWidth: .infinity)
                }
            }
            .presentationDetents([.height(400)])
            .presentationCornerRadius(35)
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    Text("sheet")
        .sheet(isPresented: .constant(true)) {
            NeedLoginSheet(type: .userInfo) {
                // action here
            }
        }
}
