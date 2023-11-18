//
//  UnderlineButton.swift
//  Outline
//
//  Created by 김하은 on 11/18/23.
//

import SwiftUI

struct UnderlineButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .foregroundStyle(Color.gray300)
                    .font(.customSubbody)
                    .background(
                       Rectangle()
                           .frame(height: 1)
                           .foregroundColor(Color.gray300)
                           .offset(y: 10)
                   )
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    UnderlineButton(text: "밑줄 버튼") {
        
    }
}
