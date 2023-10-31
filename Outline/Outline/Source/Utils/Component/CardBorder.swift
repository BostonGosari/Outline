//
//  CardBorder.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct CardBorder: View {
    let cornerRadiusTopLeft: CGFloat
    let cornerRadiusTopRight: CGFloat
    let cornerRadiusBottomLeft: CGFloat
    let cornerRadiusBottomRight: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: cornerRadiusTopLeft, y: -0.5))
                path.addLine(to: CGPoint(x: geometry.size.width - cornerRadiusTopRight, y: -0.5))
                    
                path.addArc(
                    center: CGPoint(x: geometry.size.width - cornerRadiusTopRight, y: cornerRadiusTopRight-0.5),
                    radius: cornerRadiusTopRight,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false
                )
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - cornerRadiusBottomRight))
                path.addArc(
                    center: CGPoint(x: geometry.size.width - cornerRadiusBottomRight, y: geometry.size.height - cornerRadiusBottomRight-1),
                    radius: cornerRadiusBottomRight,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false
                )
                path.addLine(to: CGPoint(x: cornerRadiusBottomLeft, y: geometry.size.height-1))
                path.addArc(
                    center: CGPoint(x: cornerRadiusBottomLeft, y: geometry.size.height - cornerRadiusBottomLeft-1),
                    radius: cornerRadiusBottomLeft,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false
                )
                path.addLine(to: CGPoint(x: 0, y: cornerRadiusTopLeft))
                path.addArc(
                    center: CGPoint(x: cornerRadiusTopLeft, y: cornerRadiusTopLeft),
                    radius: cornerRadiusTopLeft,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false
                )
            }
            .stroke(Color.white, lineWidth: 1.5)
            
        }
    }
}
