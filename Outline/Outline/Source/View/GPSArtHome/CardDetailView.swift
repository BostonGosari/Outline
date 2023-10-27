//
//  CardDetailView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit

struct CardDetailView: View {
    
    @State var start = false
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    @StateObject var runningManager = RunningManager.shared
    @StateObject var locationManager = LocationManager()
    @ObservedObject var healthKitManager = HealthKitManager()
    @State var isPermissionSheetPresented : Bool = false
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShow: Bool
    var currentIndex: Int
    var namespace: Namespace.ID
    
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
    
    // 커진 카드의 크기
    private let cardHeight: CGFloat = 575
    
    @State var isUnlocked: Bool = false
    var body: some View {
        ScrollView {
            ZStack {
                Color.gray900Color
                    .onScrollViewOffsetChanged { value in
                        handleScrollViewOffset(value)
                    }
                
                VStack {
                    ZStack {
                        courseImage
                        courseInformation
                    }
                    CardDetailInformationView(homeTabViewModel: homeTabViewModel, currentIndex: currentIndex)
                        .opacity(appear[2] ? 1 : 0)
                        .offset(y: appear[2] ? 0 : fadeInOffset)
                }
                .mask(
                    RoundedRectangle(cornerRadius: viewSize / 2, style: .continuous)
                )
                .scaleEffect(viewSize / -600 + 1)
                .gesture(isDraggable ? drag : nil)
            }
            .onChange(of: isShow) { _, _ in
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
        AsyncImage(url: URL(string: homeTabViewModel.recommendedCoures[currentIndex].course.thumbnail)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle()
                .scaledToFit()
        }
        .foregroundColor(.gray800)
        .roundedCorners(45, corners: [.bottomLeft])
        .shadow(color: .white, radius: 0.5, y: 0.5)
        .matchedGeometryEffect(id: "courseImage\(currentIndex)", in: namespace)
        .frame(height: cardHeight)
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(homeTabViewModel.recommendedCoures[currentIndex].course.courseName)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("\(homeTabViewModel.recommendedCoures[currentIndex].course.locationInfo.locality) \(homeTabViewModel.recommendedCoures[currentIndex].course.locationInfo.subLocality) • 내 위치에서 \(homeTabViewModel.recommendedCoures[currentIndex].distance/1000, specifier: "%.1f")km")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.bottom, 16)
                
                HStack {
                    Text("#\(homeTabViewModel.recommendedCoures[currentIndex].course.courseLength, specifier: "%.0f")km")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                    Text("#\(formatDuration(homeTabViewModel.recommendedCoures[currentIndex].course.courseDuration))")
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
            SlideToUnlock(isUnlocked: $isUnlocked)
                .onChange(of: isUnlocked) { _, _ in
                    if !locationManager.isAuthorized || !healthKitManager.isAuthorized {
                        isPermissionSheetPresented = true
                    } else {
                        runningManager.startCourse = homeTabViewModel.recommendedCoures[currentIndex].course
                        runningManager.startGPSArtRun()
                        isShow = false
                        }
                    }
                .opacity(appear[1] ? 1 : 0)
                .offset(y: appear[1] ? 0 : fadeInOffset)
                .padding(-10)
            }
            .padding(-10)
            .sheet(isPresented: $isPermissionSheetPresented) {
                if !locationManager.isAuthorized {
                    PermissionSheetView(type: "location", ispresented: $isPermissionSheetPresented)
                } else {
                    PermissionSheetView(type: "health", ispresented:  $isPermissionSheetPresented)
            }
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
                .foregroundColor(viewSize > 15 ? .clear : .primaryColor)
        }
        .animation(.easeInOut, value: viewSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(30)
        .opacity(appear[1] ? 1 : 0)
        .offset(y: appear[1] ? 0 : fadeInOffset)
    }
}

// MARK: - Drag Gesture

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
                if viewSize >= dragLimit {
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

// MARK: - View Functions

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

#Preview {
    HomeTabView()
}
