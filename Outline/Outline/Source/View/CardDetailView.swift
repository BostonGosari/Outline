//
//  CardDetailView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CardDetailView: View {
    
    @Namespace var namespace
    @State private var isShow = true

    @State private var appear = [false, false, false]
    @State private var viewSize = 0.0
    @State private var scrollViewOffset: CGFloat = 0
    @State private var dragState: CGSize = .zero
    
    private let fadeInOffset: CGFloat = 10
    private let dragStartRange: CGFloat = 60
    private let scrollStartRange: CGFloat = 5
    private let dragLimit: CGFloat = 60
    private let scrollLimit: CGFloat = 40
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.clear
                    .onScrollViewOffsetChanged { value in
                        handleScrollViewOffset(value)
                    }
                
                VStack {
                    ZStack {
                        mapImage
                        mapInformation
                    }
                    detailInformation
                }
                .mask(RoundedRectangle(cornerRadius: viewSize / 3, style: .continuous))
                .scaleEffect(viewSize / -600 + 1)
                .gesture(drag)
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
        .ignoresSafeArea(edges: .top)
        .statusBarHidden()
    }
}

// MARK: View Components

extension CardDetailView {
    
    private var mapImage: some View {
        Image("MapSample")
            .resizable()
            .scaledToFit()
            .roundedCorners(40, corners: [.bottomLeft, .bottomRight])
            .matchedGeometryEffect(id: "map", in: namespace)
    }
    
    private var mapInformation: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Text("오리런")
                    .font(.title)
                    .bold()
                    .matchedGeometryEffect(id: "title", in: namespace)
                HStack {
                    Image(systemName: "map.fill")
                    Text("건국대학교")
                }
                .matchedGeometryEffect(id: "subtitle", in: namespace)
            }
            .padding(.top, 20)
            
            Spacer()
            
            Button {
            } label: {
                Text("시작하기")
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
        .foregroundStyle(.white)
        .padding(40)
    }
    
    private var closeButton: some View {
        Button {
            withAnimation(.closeCard) {
                isShow = false
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundStyle(viewSize > 15 ? .clear : scrollViewOffset < -200 ? .black : .gray)
        }
        .animation(.easeInOut, value: scrollViewOffset)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(30)
        .opacity(appear[0] ? 1 : 0)
        .offset(y: appear[0] ? 0 : fadeInOffset)
    }
    
    private var detailInformation: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("난이도 상, 골목길 가파름")
                .font(.title3)
                .bold()
            Text("안녕하세요 어쩌구 하이 고래 귀엽\n마리오 슈퍼마리오 스파게티")
            
            Divider()
            Text("뷰에 사용되는 값들")
                .font(.title3)
                .bold()
            HStack {
                VStack(alignment: .leading) {
                    Text("viewSize")
                    Text("scrollViewOffset")
                    Text("dragState.width")
                }
                .font(.headline)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(viewSize)")
                    Text("\(scrollViewOffset)")
                    Text("\(dragState.width)")
                }
            }
        }
        .opacity(appear[2] ? 1 : 0)
        .offset(y: appear[2] ? 0 : fadeInOffset)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top)
        .padding(.horizontal, 40)
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
                viewSize = scrollViewOffset
                
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

extension Animation {
    static let openCard = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let closeCard = Animation.spring(response: 0.4, dampingFraction: 0.5)
}

#Preview {
    CardDetailView()
}
