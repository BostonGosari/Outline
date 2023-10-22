//
//  BackgroundBlur.swift
//  Outline
//
//  Created by 김하은 on 10/16/23.
//

import SwiftUI

struct BackgroundBlur: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 289, height: 289)
            .background(Color.primaryColor)
            .cornerRadius(289)
            .blur(radius: 150)
            .padding(.top, 500)
    }
}
