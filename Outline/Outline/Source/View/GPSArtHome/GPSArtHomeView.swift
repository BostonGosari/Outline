//
//  GPSArtHomeView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI

struct GPSArtHomeView: View {
    
    @ObservedObject var vm: HomeTabViewModel

    @State private var scrollOffset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    // 받아오는 변수
    @Binding var isShow: Bool
    var namespace: Namespace.ID
    
    // Carousel 에 필요한 변수들
    let pageCount = 3
    let edgeSpace: CGFloat = 36
    let spacing: CGFloat = 20
    
    // 뷰에 있는 요소들의 사이즈 조정
    let carouselFrameHeight: CGFloat = 484
    let indexWidth: CGFloat = 25
    let indexHeight: CGFloat = 3
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                Color.clear.frame(height: 0)
                    .onScrollViewOffsetChanged { offset in
                        scrollOffset = offset
                    }
                Header(scrollOffset: scrollOffset)
                    .padding(.bottom)
                
                VStack(spacing: 16) {
                    Carousel(pageCount: pageCount, edgeSpace: edgeSpace, spacing: spacing, currentIndex: $currentIndex) { pageIndex in
                        if !isShow {
                            CardView(vm: vm, isShow: $isShow, currentIndex: $currentIndex, namespace: namespace, pageIndex: pageIndex)
                                .transition(
                                    .asymmetric(
                                        insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                                        removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                                    )
                                )
                        }
                    }
                    .frame(height: carouselFrameHeight)
                    
                    HStack {
                        ForEach(0..<pageCount, id: \.self) { pageIndex in
                            Rectangle()
                                .frame(width: indexWidth, height: indexHeight)
                                .foregroundColor(currentIndex == pageIndex ? .primaryColor : .white)
                                .animation(.easeInOut, value: currentIndex)
                        }
                    }
                    BottomScrollView(vm: vm)
                }
            }
            .overlay(alignment: .top) {
                InlineHeader(scrollOffset: scrollOffset)
            }
            
            if isShow {
                Color.gray900Color.ignoresSafeArea()
                CardDetailView(vm: vm, isShow: $isShow, currentIndex: currentIndex, namespace: namespace)
                    .zIndex(1)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                            removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                        )
                    )
                    .ignoresSafeArea()
            }
        }
        .background(
            BackgroundBlur()
        )
    }
}
