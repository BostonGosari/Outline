//
//  CarouselView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CarouselView: View {
    
    @State var currentIndex = 0

    let pageCount = 3
    let edgeSpace: CGFloat = 36
    let spacing: CGFloat = 10
    
    let cardWidth: CGFloat = 318
    let cardHeight: CGFloat = 484
    let indexWidth: CGFloat = 25
    let indexHeight: CGFloat = 3
    
    var body: some View {
        VStack(spacing: 16) {
            Carousel(pageCount: pageCount, edgeSpace: edgeSpace, spacing: spacing, currentIndex: $currentIndex) { _ in
                CardView()
            }
            .frame(height: cardHeight)
            
            HStack {
                ForEach(0..<pageCount, id: \.self) { pageIndex in
                    Rectangle()
                        .frame(width: indexWidth, height: indexHeight)
                        .foregroundColor(currentIndex == pageIndex ? .firstColor : .white)
                        .animation(.spring, value: currentIndex)
                }
            }
        }
    }
}

#Preview {
    CarouselView()
}
