//
//  ControlButton.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/2/23.
//

import SwiftUI

struct ControlButton: View {
    let systemName: String
    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 24))
                .fontWeight(.black)
                .foregroundColor(foregroundColor)
                .padding()
                .overlay(
                    Circle()
                        .stroke(foregroundColor, lineWidth: 2)
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .foregroundColor(backgroundColor)
                                .opacity(0.5)
                        )
                )
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
}
