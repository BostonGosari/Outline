//
//  FreeRunningHomeView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct FreeRunningHomeView: View {
    
    @StateObject var locationManager = LocationManager()
    @State var userLocation = ""
    
    var body: some View {
        ZStack {
            FreeRunningMap(userLocation: $userLocation)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Header(scrollOffset: 20)
                    .padding(.top, 8)
                Spacer()
                
                cardView
                   .overlay {
                       VStack(alignment: .leading) {
                           Text("자유 코스")
                               .font(.headline)
                               .padding(.bottom, 8)
                           
                           HStack {
                               Image(systemName: "mappin")
                               Text(userLocation)
                           }
                           .font(.subBody)
                           
                           Spacer()
                           SlideToUnlock()
                       }
                       .padding(EdgeInsets(top: 58, leading: 24, bottom: 24, trailing: 16))
                   }
                   .padding(EdgeInsets(top: 8, leading: 16, bottom: 80, trailing: 20))
            }
        }
        .preferredColorScheme(.dark)

    }
}

extension FreeRunningHomeView {
    private var cardView: some View {
        Rectangle()
            .fill(
                LinearGradient(colors: [.white20Color, .white20Color.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .roundedCorners(10, corners: [.topLeft])
            .roundedCorners(70, corners: [.topRight])
            .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
            .overlay(
                CardBorder(cornerRadiusTopLeft: 10, cornerRadiusTopRight: 79, cornerRadiusBottomLeft: 45, cornerRadiusBottomRight: 45)
            )
        
    }
}

private struct CardBorder: View {
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

#Preview {
    FreeRunningHomeView()
}