//
//  CardDetailView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit
import Kingfisher

struct CardDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = CardDetailViewModel()
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            ScrollView {
                ZStack(alignment: .top) {
                    Color.gray900
                        .onScrollViewOffsetChanged { value in
                            viewModel.handleScrollViewOffset(value)
                        }
                    
                    VStack {
                        ZStack(alignment: .top) {
                            if viewModel.showDetailView {
                                courseImage
                                courseInformation
                            } else {
                                UnevenRoundedRectangle(bottomTrailingRadius: 45, style: .circular)
                                    .frame(
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height * 0.68
                                    )
                                    .foregroundStyle(.clear)
                            }
                        }
                        
                        CardDetailInformationView(
                            showCopyLocationPopup: $viewModel.showCopyLocationPopup,
                            selectedCourse: viewModel.selectedCourse?.course
                        )
                        .opacity(viewModel.appear[2] ? 1 : 0)
                        .offset(y: viewModel.appear[2] ? 0 : viewModel.fadeInOffset)
                    }
                    .mask(
                        RoundedRectangle(cornerRadius: viewModel.viewSize / 2, style: .continuous)
                    )
                    .scaleEffect(viewModel.showDetailView ? max(viewModel.viewSize / -600 + 1, 0.9) : 0.9)
                    .gesture(viewModel.isDraggable ? drag : nil)

                    slideToUnlock
                        .padding(.top, UIScreen.main.bounds.height * 0.68 - 95)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .zIndex(1)
                    
                    closeButton
                    
                    Color.black
                        .opacity(viewModel.progress * 0.8)
                        .animation(.easeInOut, value: viewModel.progress)
                }
                .onChange(of: viewModel.showDetailView) { _, _ in
                    viewModel.fadeOut()
                }
                .onAppear {
                    viewModel.fadeIn()
                }
            }
            .scrollIndicators(viewModel.scrollViewOffset > viewModel.scrollStartRange ? .hidden : .automatic)
            .scrollDisabled(!viewModel.showDetailView)
            .ignoresSafeArea(edges: .top)
            .statusBarHidden()
        }
        .overlay {
            if viewModel.showCopyLocationPopup {
                RunningPopup(text: "시작 위치 도로명이 복사되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 52)
            } else {
                EmptyView()
            }
        }
        .sheet(isPresented: $viewModel.showAlert) {
            viewModel.progress = 0.0
        } content: {
            GuideToFreeRunningSheet {
                viewModel.changeToFreeRunning()
            }
        }
        .sheet(isPresented: $viewModel.showNeedLoginSheet) {
            NeedLoginSheet(type: .running) {
                viewModel.showDetailView = false
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    // MARK: - View Components

    @ViewBuilder
    private var courseImage: some View {
        if let selectedCourse = viewModel.selectedCourse {
            KFImage(URL(string: selectedCourse.course.thumbnail))
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(.clear)
                }
                .mask {
                    UnevenRoundedRectangle(bottomTrailingRadius: 45, style: .circular)
                }
                .overlay {
                    UnevenRoundedRectangle(bottomTrailingRadius: 45, style: .circular)
                        .stroke(LinearGradient(colors: [.gray600, .clear, .clear, .clear], startPoint: .bottomTrailing, endPoint: .top), lineWidth: 1)
                }
                .matchedGeometryEffect(id: selectedCourse.id, in: namespace)
                .frame(
                    //                width: UIScreen.main.bounds.width + 2,
                    height: UIScreen.main.bounds.height * 0.68
                )
                .offset(y: -1)
        }

    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(viewModel.selectedCourse?.course.courseName ?? "")")
                    .font(.customHeadline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("\(viewModel.selectedCourse?.course.locationInfo.locality ?? "") \(viewModel.selectedCourse?.course.locationInfo.subLocality ?? "") • 내 위치에서 \((viewModel.selectedCourse?.distance ?? 0)/1000, specifier: "%.1f")km")
                }
                .font(.customSubbody)
                .fontWeight(.regular)
                .foregroundStyle(.gray400)
                .padding(.bottom, 16)
            }
            .padding(.top, getSafeArea().bottom == 0 ? 30 : 60)
            .opacity(viewModel.appear[0] ? 1 : 0)
            .offset(y: viewModel.appear[0] ? 0 : viewModel.fadeInOffset)
        }
        .padding(40)
        .padding(.bottom, 80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(alignment: .bottom) {
            LinearGradient(colors: [.black20, .black70, .black70, .black20, .black10], startPoint: .top, endPoint: .bottom)
        }
    }
    
    private var slideToUnlock: some View {
        SlideToUnlock(isUnlocked: $viewModel.isUnlocked, progress: $viewModel.progress)
            .opacity(viewModel.appear[1] ? 1 : 0)
            .offset(y: viewModel.appear[1] ? 0 : viewModel.fadeInOffset)
            .padding(-10)
    }
    
    private var closeButton: some View {
        Button {
            withAnimation(.easeInOut) {
                viewModel.showDetailView = false
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(viewModel.viewSize > 15 ? .clear : .customPrimary)
        }
        .animation(.easeInOut, value: viewModel.viewSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        .opacity(viewModel.appear[1] ? 1 : 0)
        .offset(y: viewModel.appear[1] ? 0 : viewModel.fadeInOffset)
    }
}

// MARK: - Drag Gesture

extension CardDetailView {
    var drag: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { value in
                viewModel.onDrag(value)
            }
            .onEnded { _ in
                viewModel.dragEnded()
            }
    }
}


#Preview {
    HomeTabView()
}
