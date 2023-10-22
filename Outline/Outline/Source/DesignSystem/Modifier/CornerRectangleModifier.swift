//
//  CornerRectangleModifier.swift
//  Outline
//
//  Created by hyebin on 10/20/23.
//

import SwiftUI

struct CornerRectangleModifier: ViewModifier {
    let topLeft: CGFloat
    let topRight: CGFloat
    let bottom: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                CustomRoundedRectangle(cornerRadiusTopLeft: topLeft, cornerRadiusTopRight: topRight, cornerRadiusBottomLeft: bottom, cornerRadiusBottomRight: bottom)
            )
            .roundedCorners(topLeft, corners: [.topLeft])
            .roundedCorners(topRight, corners: [.topRight])
            .roundedCorners(bottom, corners: [.bottomLeft, .bottomRight])
    }
}
