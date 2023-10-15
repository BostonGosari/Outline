//
//  CardDetailView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CardDetailView: View {
    
    @Binding var isShow: Bool
    var namespace: Namespace.ID
    var currentIndex: Int
    
    @State private var appear = [false, false, false]
    @State private var viewSize = 0.0
    @State private var scrollViewOffset: CGFloat = 0
    @State private var dragState: CGSize = .zero
    @State private var isDraggable = true
    
    private let fadeInOffset: CGFloat = 10
    private let dragStartRange: CGFloat = 60
    private let scrollStartRange: CGFloat = 10
    private let dragLimit: CGFloat = 60
    private let scrollLimit: CGFloat = 40
    
    var body: some View {
        ScrollView {
            ZStack {
                Color(UIColor.systemBackground)
                    .onScrollViewOffsetChanged { value in
                        handleScrollViewOffset(value)
                    }
                
                VStack {
                    ZStack {
                        courseImage
                        courseInformation
                    }
                    CardDetailInformationView()
                        .opacity(appear[2] ? 1 : 0)
                        .offset(y: appear[2] ? 0 : fadeInOffset)
                }
                .mask(
                    RoundedRectangle(cornerRadius: viewSize / 2, style: .continuous)
                )
                .scaleEffect(viewSize / -600 + 1)
                .gesture(isDraggable ? drag : nil)
            }
            .onChange(of: isShow) { _ in
                fadeOut()
            }
            .onAppear {
                fadeIn()
            }
        }
        .overlay {
            closeButton
        }
        .scrollIndicators(scrollViewOffset > scrollStartRange ? .hidden : .automatic)
        .ignoresSafeArea(edges: .top)
        .statusBarHidden()
    }
    
    // MARK: - View Components
    
    private var courseImage: some View {
        Rectangle()
            .frame(height: 575)
            .foregroundColor(.gray900Color)
            .roundedCorners(45, corners: [.bottomLeft])
            .shadow(color: .white, radius: 1, y: -0.5)
            .matchedGeometryEffect(id: "courseImage\(currentIndex)", in: namespace)
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("시티런 \(currentIndex)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("서울시 동작구 • 내 위치에서 5km")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.bottom, 16)
                HStack {
                    Text("#5km")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                    Text("#2h39m")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                }
                .font(.caption)
            }
            .padding(.top, 100)
            .opacity(appear[0] ? 1 : 0)
            .offset(y: appear[0] ? 0 : fadeInOffset)
            
            Spacer()
            
            Button {
            } label: {
                Text("밀어서 시작하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundStyle(.ultraThinMaterial)
                    }
            }
            .opacity(appear[1] ? 1 : 0)
            .offset(y: appear[1] ? 0 : fadeInOffset)
            .padding(-10)
        }
        .padding(40)
    }
    
    private var closeButton: some View {
        Button {
            withAnimation(.closeCard) {
                isShow.toggle()
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(viewSize > 15 ? .clear : .firstColor)
        }
        .animation(.easeInOut, value: viewSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(30)
        .opacity(appear[1] ? 1 : 0)
        .offset(y: appear[1] ? 0 : fadeInOffset)
    }
}

// MARK: Drag Gesture

extension CardDetailView {
    var drag: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { value in
                if value.translation.width > 0 {
                    if value.startLocation.x < dragStartRange {
                        withAnimation {
                            dragState = value.translation
                            viewSize = dragState.width
                        }
                        if viewSize > dragLimit {
                            withAnimation(.closeCard) {
                                isShow = false
                                dragState = .zero
                            }
                        }
                    }
                } else {
                    if value.startLocation.x > UIScreen.main.bounds.width - dragStartRange {
                        withAnimation {
                            dragState = value.translation
                            viewSize = -dragState.width
                        }
                        
                        if viewSize > dragLimit {
                            withAnimation(.closeCard) {
                                isShow = false
                                dragState = .zero
                                viewSize = 0.0
                            }
                        }
                    }
                }
            }
            .onEnded { _ in
                if viewSize > dragLimit {
                    withAnimation(.closeCard) {
                        isShow = false
                        viewSize = 0.0
                    }
                } else {
                    withAnimation {
                        dragState = .zero
                        viewSize = 0.0
                    }
                }
            }
    }
}

// MARK: View Functions

extension CardDetailView {
    
    private func close() {
        withAnimation(.closeCard.delay(0.3)) {
            isShow = false
        }
        
        withAnimation(.closeCard) {
            viewSize = .zero
        }
        
        isDraggable = false
    }
    
    private func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.45)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.6)) {
            appear[2] = true
        }
    }
    
    private func fadeOut() {
        withAnimation(.easeIn(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
        }
    }
    
    private func handleScrollViewOffset(_ value: CGFloat) {
        if dragState.width == 0 {
            scrollViewOffset = value
            
            if scrollViewOffset > scrollStartRange {
                viewSize = scrollViewOffset - scrollStartRange
                
                if scrollViewOffset > scrollLimit {
                    withAnimation(.closeCard) {
                        isShow = false
                    }
                }
            } else {
                viewSize = 0
            }
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {

    /// ```swift
    /// @State private var scrollViewOffset: CGFloat = 0
    ///
    /// .onScrollViewOffsetChanged { value
    ///    in scrollViewOffset = value
    /// }
    /// ```
    /// scrollViewOffset 변수 선언을 해준뒤 함수를 사용하여 scrollViewOffset 의 변화를 추적
    func onScrollViewOffsetChanged(action: @escaping (_ offset: CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader {geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                action(value)
            }
    }
}

#Preview {
    CarouselView()
}
