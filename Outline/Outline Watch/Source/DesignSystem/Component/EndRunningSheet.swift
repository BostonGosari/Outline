//
//  EndRunningSheet.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

struct EndRunningSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var text: String
    var action: () -> Void
    
    var body: some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
                .font(.customBody)
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("계속 진행하기")
                    .font(.customButton)
                    .foregroundStyle(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundStyle(.gray800.opacity(0.5))
                    )
            }
            .buttonStyle(.plain)
            
            Button(action: action) {
                Text("종료하기")
                    .font(.customButton)
                    .foregroundStyle(.black)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundStyle(.customPrimary)
                    )
            }
            .buttonStyle(.plain)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
