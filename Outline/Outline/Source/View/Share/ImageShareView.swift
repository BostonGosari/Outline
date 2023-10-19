//
//  ImageShareView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct ImageShareView: View {
    
    @ObservedObject var viewModel: ShareViewModel
    
    @State private var isPhotoMode = false
    @State private var showSheet = false
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            Color.gray900Color
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    if isPhotoMode {
                        selectPhotoMode
                    } else {
                        blackShareImageMode
                    }
                }
                .aspectRatio(1080/1920, contentMode: .fit)
                .padding(EdgeInsets(top: 20, leading: 49, bottom: 16, trailing: 49))
              
                pageIndicator
                selectModeView
            }
        }
        .confirmationDialog("이미지 선택", isPresented: $showSheet) {
            Button("사진 찍기") {
                viewModel.checkCameraPermission()
            }
            Button("이미지 선택") {
                viewModel.checkAlbumPermission()
            }
            
            Button("Cancel", role: .cancel) {}
        }
        
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            ImagePickerView(selectedImage: $image, sourceType: .camera)
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePickerView(selectedImage: $image)
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.permissionDenied) {
            Button("설정으로", role: .cancel) {
                // move to 설정
            }
        }
    }
}

extension ImageShareView {
    private var selectPhotoMode: AnyView {
        if let img = image {
            AnyView(
                Image(uiImage: image!)
                    .resizable()
                    .mask {
                        Rectangle()
                            .aspectRatio(1080/1920, contentMode: .fit)
                    }
            )
        } else {
            AnyView(
                Button {
                    showSheet = true
                } label: {
                    Rectangle()
                }
            )
        }
    }
    
    private var blackShareImageMode: some View {
        Rectangle()
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.whiteColor)
                .frame(width: 25, height: 3)
                .padding(.trailing, 5)
            
            Rectangle()
                .fill(Color.primaryColor)
                .frame(width: 25, height: 3)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 168)
        .padding(.bottom, 32)
    }
    
    private var selectModeView: some View {
        HStack(spacing: 0) {
            Button {
                isPhotoMode = false
            } label: {
                Circle()
                    .fill(.black)
                    .stroke(isPhotoMode ?  Color.gray200Color : Color.primaryColor, lineWidth: 5)
            }
            .padding(.horizontal, 12)
            
            Button {
                isPhotoMode = true
            } label: {
                Circle()
                    .fill(.white)
                    .stroke(isPhotoMode ? Color.primaryColor : Color.gray200Color, lineWidth: 5)
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 143)
        .padding(.bottom, 110)
    }
}
