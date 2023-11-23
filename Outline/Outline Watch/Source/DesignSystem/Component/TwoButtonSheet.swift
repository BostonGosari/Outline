//
//  TwoButtonSheet.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/16/23.
//

import SwiftUI

struct TwoButtonSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var text: String
    var firstLabel: String
    var firstAction: () -> Void
    var secondLabel: String
    var secondAction: () -> Void
    
    var body: some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
                .font(.customBody)
            Spacer()
            
            Button {
                dismiss()
                firstAction()
            } label: {
                Text(firstLabel)
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
            
            Button {
                dismiss()
                secondAction()
            } label: {
                Text(secondLabel)
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
