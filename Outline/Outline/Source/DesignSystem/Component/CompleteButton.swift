//
//  CompleteButton.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import SwiftUI

struct CompleteButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button {
            self.action()
        }  label: {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.primaryColor)
                .frame(height: 55)
                .padding(.horizontal, 16)
                .overlay {
                    Text(text)
                        .foregroundStyle(Color.black)
                        .font(.button)
                }
        }
    }
}

#Preview {
    CompleteButton(text: "자랑하기") {
        
    }
}
