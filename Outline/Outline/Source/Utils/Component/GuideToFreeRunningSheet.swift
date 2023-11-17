//
//  GuideToFreeRunningSheet.swift
//  Outline
//
//  Created by hyunjun on 11/17/23.
//

import SwiftUI

struct GuideToFreeRunningSheet: View {
    @Environment(\.dismiss) var dismiss
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(lineWidth: 2)
                .foregroundStyle(Gradient(colors: [.customPrimary, .gray900, .gray900, .gray900]))
                .ignoresSafeArea()
            VStack(spacing: 10) {
                Text("자유코스로 변경할까요?")
                    .font(.customTitle2)
                    .fontWeight(.semibold)
                    .padding(.top, 36)
                Text("앗! 현재 루트와 멀리 떨어져 있어요.")
                    .font(.customSubbody)
                    .foregroundColor(.gray300)
                    .multilineTextAlignment(.center)
                Image("AnotherLocation")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                Button {
                    dismiss()
                } label: {
                    Text("자유코스로 변경하기")
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
                    action()
                } label: {
                    Text("돌아가기")
                        .font(.customBody)
                        .foregroundStyle(.customWhite)
                        .frame(maxWidth: .infinity)
                }
            }
            .presentationDetents([.height(400)])
            .presentationCornerRadius(35)
        }
    }
}

#Preview {
    Text("sheet")
        .sheet(isPresented: .constant(true)) {
            GuideToFreeRunningSheet {
                
            }
        }
}
