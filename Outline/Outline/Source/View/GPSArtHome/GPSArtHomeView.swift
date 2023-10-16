//
//  GPSArtHomeView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI

struct GPSArtHomeView: View {
    @State private var scrollOffset: CGFloat = 0
    let scroll = 0
    
    var namespace: Namespace.ID
    @Binding var isShow: Bool
    @Binding var currentIndex: Int
    
    let pageCount = 3
    let edgeSpace: CGFloat = 36
    let spacing: CGFloat = 20
    
    let cardWidth: CGFloat = 318
    let cardHeight: CGFloat = 484
    let indexWidth: CGFloat = 25
    let indexHeight: CGFloat = 3
    
    var body: some View {
        NavigationStack {
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
                }
                .overlay(alignment: .top) {
                    InlineHeader(scrollOffset: scrollOffset)
                }
            }
            .background(
                BackgroundBlur()
            )
        }
    }
}

struct Header: View {
    
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            Spacer()
            Button { } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .foregroundColor(Color.first)
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(scrollOffset >= 20 ? 1 : 0)
    }
}

struct InlineHeader: View {
    
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            Spacer()
            Button { } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .foregroundColor(Color.first)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
        )
        .opacity(scrollOffset < 20 ? 1 : 0)
    }
}

#Preview {
    TabView()
}
