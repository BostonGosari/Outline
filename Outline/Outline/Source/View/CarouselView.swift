//
//  CarouselView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CarouselView: View {
    
    @Namespace var namespace
    @State var currentIndex = 0
    @State var isShow = false
    
    let pageCount = 3
    let edgeSpace: CGFloat = 36
    let spacing: CGFloat = 16
    
    let cardWidth: CGFloat = 318
    let cardHeight: CGFloat = 484
    let indexWidth: CGFloat = 25
    let indexHeight: CGFloat = 3
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Carousel(pageCount: pageCount, edgeSpace: edgeSpace, spacing: spacing, currentIndex: $currentIndex) { pageIndex in
                    if !isShow {
                        CardView(namespace: namespace, isShow: $isShow, currentIndex: $currentIndex, pageIndex: pageIndex)
                            .transition(
                                .asymmetric(
                                    insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                                    removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                                )
                            )
                    }
                }
                .frame(height: cardHeight)
                
                HStack {
                    ForEach(0..<pageCount, id: \.self) { pageIndex in
                        Rectangle()
                            .frame(width: indexWidth, height: indexHeight)
                            .foregroundColor(currentIndex == pageIndex ? .firstColor : .white)
                            .animation(.easeInOut, value: currentIndex)
                    }
                }
            }
            
            if isShow {
                CardDetailView(namespace: namespace, isShow: $isShow, currentIndex: currentIndex)
                    .zIndex(1)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                            removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                        )
                    )
            }
        }
    }
}

#Preview {
    CarouselView()
}
