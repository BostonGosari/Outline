//
//  RunningPopup.swift
//  Outline
//
//  Created by hyebin on 10/17/23.
//

import SwiftUI

struct RunningPopup: View {
    
    var text: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(Color.black70)
            .strokeBorder(Color.customPrimary)
            .frame(height: 54)
            .padding(.horizontal, 24)
            .overlay {
                Text(text)
                    .foregroundStyle(Color.white)
                    .font(.subBody)
            }
    }
}

#Preview {
    RunningPopup(text: "일시정지를 3초동안 누르면 러닝이 종료돼요")
}
