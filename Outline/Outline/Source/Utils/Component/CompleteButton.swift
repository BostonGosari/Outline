//
//  CompleteButton.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import SwiftUI

struct CompleteButton: View {
    let text: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 15)
                .fill(isActive ? Color.customPrimary : Color.gray700)
                .frame(height: 55)
                .padding(.horizontal, 16)
                .overlay {
                    Text(text)
                        .foregroundStyle(isActive ? Color.black : Color.customWhite)
                        .font(.customButton)
                }
        }
        .disabled(!isActive)
    }
}

#Preview {
    CompleteButton(text: "자랑하기", isActive: true) {
        
    }
}
