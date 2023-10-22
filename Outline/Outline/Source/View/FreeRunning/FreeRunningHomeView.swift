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
            .modifier(
                CornerRectangleModifier(topLeft: 10, topRight: 79, bottom: 45)
            )
        
    }
}

#Preview {
    FreeRunningHomeView()
}
