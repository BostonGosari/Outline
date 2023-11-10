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
    @StateObject private var viewModel = ShareViewModel()
    
    @State private var isShowPermissionSheet = false
    
    let runningData: ShareModel
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            TabView(selection: $viewModel.currentPage) {
                CustomShareView(viewModel: viewModel)
                    .tag(0)
                ImageShareView(viewModel: viewModel)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack(spacing: 0) {
                Button {
                    viewModel.tapSaveButton = true
                }  label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundStyle(Color.black)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.vertical, 14)
                        .padding(.horizontal, 19)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.customWhite)
                        }
                }
                .padding(.leading, 16)
                
                CompleteButton(text: "공유하기", isActive: true) {
                    viewModel.tapShareButton = true
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
            if isShowPermissionSheet {
                permissionSheet
            }
        }
        .onChange(of: viewModel.permissionDenied) {
            if viewModel.permissionDenied {
                isShowPermissionSheet = true
            }
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: "이미지 저장이 완료되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

extension ShareMainView {
    private var permissionSheet: some View {
        ZStack {
            Color.black.opacity(0.5)
                .onTapGesture {
                    viewModel.permissionDenied = false
                    isShowPermissionSheet = false
                }
            
            VStack(spacing: 0) {
                Text(viewModel.alertTitle)
                    .font(.customTitle2)
                    .padding(.top, 44)
                    .padding(.bottom, 8)
                
                Text(viewModel.alertMessage)
                    .font(.customSubbody)
                    .padding(.bottom, 30)
                
                Image(viewModel.imageName)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 26)
                
                CompleteButton(text: "설정으로 가기", isActive: true) {
                    viewModel.openAppSetting()
                    viewModel.permissionDenied = false
                    isShowPermissionSheet = false
                }
                .padding(.bottom, 20)
                
                Button("닫기") {
                    viewModel.permissionDenied = false
                    isShowPermissionSheet = false
                }
                .foregroundStyle(Color.customWhite)
                .padding(.bottom, 40)
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color.customPrimary, lineWidth: 2)
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(Color.gray900)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .animation(.easeInOut, value: isShowPermissionSheet)
        }
        .ignoresSafeArea()
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
