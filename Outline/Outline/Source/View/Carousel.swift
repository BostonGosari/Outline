//
//  Carousel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct Carousel<Content: View>: View {
    typealias PageIndex = Int
    
    let pageCount: Int
    let edgeSpace: CGFloat
    let spacing: CGFloat
    let content: (PageIndex) -> Content
    
    @GestureState private var dragOffset: CGFloat = 0
    @Binding var currentIndex: Int
    
    init(
        pageCount: Int,
        edgeSpace: CGFloat,
        spacing: CGFloat,
        currentIndex: Binding<Int>,
        @ViewBuilder content: @escaping (PageIndex) -> Content
    ) {
        self.pageCount = pageCount
        self.edgeSpace = edgeSpace
        self.spacing = edgeSpace - spacing
        self._currentIndex = currentIndex
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            carouselHStack(in: proxy)
                .offset(x: offsetX(in: proxy))
                .gesture(dragGesture(in: proxy))
                .animation(.spring(), value: dragOffset)
        }
    }
    
    // MARK: - 뷰 컴포넌트
    
    private func carouselHStack(in proxy: GeometryProxy) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<pageCount, id: \.self) { pageIndex in
                content(pageIndex)
                    .frame(width: pageWidth(in: proxy), height: proxy.size.height)
                    .scaleEffect(calculateScale(pageIndex: pageIndex, pageWidth: pageWidth(in: proxy)))
            }
        }
        .contentShape(Rectangle())
    }
    
    // MARK: - 계산식
    
    private func offsetX(in proxy: GeometryProxy) -> CGFloat {
        let baseOffset = spacing + edgeSpace
        return baseOffset + CGFloat(currentIndex) * -pageWidth(in: proxy) + CGFloat(currentIndex) * -spacing + dragOffset
    }
    
    private func pageWidth(in proxy: GeometryProxy) -> CGFloat {
        proxy.size.width - (edgeSpace + spacing) * 2
    }
    
    // MARK: - 제스처
    
    private func dragGesture(in proxy: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                handleDragEnd(value, pageWidth: pageWidth(in: proxy))
            }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value, pageWidth: CGFloat) {
        let offsetX = value.translation.width
        let progress = -offsetX / pageWidth
        let increment = Int(progress.rounded())
        currentIndex = max(min(currentIndex + increment, pageCount - 1), 0)
    }
    
    // MARK: - 스케일 계산
    
    private func calculateScale(pageIndex: Int, pageWidth: CGFloat) -> CGFloat {
        let minScale: CGFloat = 0.8
        let maxScale: CGFloat = 1.0
        let distanceToCurrent = abs(pageIndex - currentIndex)
        let dragDistance = abs(dragOffset)
        
        if distanceToCurrent > 0 {
            return minScale + dragDistance / pageWidth * (maxScale - minScale)
        } else {
            return maxScale - dragDistance / pageWidth * (maxScale - minScale)
        }
    }
}
