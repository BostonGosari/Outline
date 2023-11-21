//
//  Mirroringsheet.swift
//  Outline
//
//  Created by hyunjun on 11/22/23.
//

import SwiftUI

struct Mirroringsheet: View {
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
                Text("Apple Watch로 러닝을\n추적하고 있어요")
                    .font(.customTitle2)
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
                    .padding(.top, 36)
                Image("RunningWatch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                Text("OUTLINE iPhone에서\n현재 Apple watch의 러닝을 미러링합니다.")
                    .font(.customSubbody)
                    .foregroundColor(.gray300)
                    .multilineTextAlignment(.center)
                Button {
                    dismiss()
                    action()
                } label: {
                    Text("미러링하기")
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
                    Text("돌아가기")
                        .font(.customBody)
                        .foregroundStyle(.customWhite)
                        .frame(maxWidth: .infinity)
                }
            }
            .presentationDetents([.height(440)])
            .presentationCornerRadius(35)
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    Text("sheet")
        .sheet(isPresented: .constant(true)) {
            Mirroringsheet {
                
            }
        }
}
