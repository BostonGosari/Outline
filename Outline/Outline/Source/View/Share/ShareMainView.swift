//
//  ShareMainView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import CoreLocation
import SwiftUI

struct ShareMainView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var runningManager = RunningStartManager.shared
    @StateObject private var viewModel = ShareViewModel()
    
    let runningData: ShareModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                
                TabView(selection: $viewModel.currentPage) {
                    CustomShareView(viewModel: viewModel, renderedImage: $viewModel.customImage)
                        .tag(0)
                    ImageShareView(viewModel: viewModel, shareImage: $viewModel.posterImage)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 0) {
                    Button {
                        viewModel.saveImage()
                    }  label: {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 19)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.customWhite)
                            }
                    }
                    .padding(.leading, 16)
                    
                    CompleteButton(text: "공유하기", isActive: true) {
                        viewModel.tapShareButton = true
                        if viewModel.shareToInstagram() {
                            runningManager.running = false
                        }
                    }
                    .padding(.leading, -8)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 42)
            }
            .ignoresSafeArea()
            .modifier(NavigationModifier(action: {
                dismiss()
            }))
            .onAppear {
                viewModel.runningData = runningData
            }
            .overlay {
                if viewModel.isShowPopup {
                    RunningPopup(text: "이미지 저장이 완료되었어요.")
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 74)
                }
            }
            .overlay {
                //TODO: 권한 거부시 sheet
            }
        }
    }
}

struct NavigationModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("공유")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        action()
                    } label: {
                        (Text(Image(systemName: "chevron.left")) + Text("뒤로"))
                            .foregroundStyle(Color.customPrimary)
                    }
                }
            }
    }
}
