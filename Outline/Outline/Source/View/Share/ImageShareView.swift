//
//  ImageShareView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct ImageShareView: View {
    @ObservedObject var viewModel: ShareViewModel
    
    @State private var selectPhotoMode = false
    @State private var showSheet = false
    @State private var image: UIImage?
    @State private var size: CGSize = .zero
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @State private var angle: Angle = .degrees(0)
    @State private var lastAngle: Angle = .degrees(0)
    
    @State private var pathWidth: CGFloat = 0
    @State private var pathHeight: CGFloat = 0
    
    private let imageSize: CGFloat = 200
    private let gradientColors = [
        Color.white,
        Color.white.opacity(0.1),
        Color.white.opacity(0.1),
        Color.white.opacity(0.4),
        Color.white.opacity(0.5)
    ]
        
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                mainImageView
                    .padding(EdgeInsets(top: 20, leading: 49, bottom: 16, trailing: 49))
                    .mask {
                        Rectangle()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .aspectRatio(1080.0/1920.0, contentMode: .fit)
                    }
                pageIndicator
                selectModeView
            }
        }
        .onChange(of: selectPhotoMode) {
            scale = 1
            lastScale = 0
            offset = .zero
            lastStoredOffset = .zero
            angle = .degrees(0)
            lastAngle = .degrees(0)
        }
        .modifier(SheetModifier(viewModel: viewModel, showSheet: $showSheet, image: $image))
        .onChange(of: viewModel.tapSaveButton) {
            if viewModel.currentPage == 1 {
                viewModel.saveImage(image: renderImage())
            }
        }
        .onAppear {
            let canvasSize = PathGenerateManager.calculateCanvaData(coordinates: viewModel.runningData.userLocations, width: imageSize, height: imageSize)
            self.pathWidth = CGFloat(canvasSize.width)
            self.pathHeight = CGFloat(canvasSize.height)
        }
    }
}

extension ImageShareView {
    private func renderImage() -> UIImage {
        return mainImageView.offset(y: -30).asImage(size: size)
    }
    
    private var mainImageView: some View {
        
        ZStack {
            if selectPhotoMode {
                selectPhotoView
            } else {
                blackImageView
            }
        }
        .aspectRatio(1080/1920, contentMode: .fill)
    }
    
    private var selectPhotoView: AnyView {
        if let img = image {
            AnyView(
                ZStack {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .mask {
                            Rectangle()
                                .aspectRatio(1080.0/1920.0, contentMode: .fit)
                        }
                    Image("ShareVinyl")
                        .resizable()
                        .opacity(0.5)
                    Image("ShareWhite1")
                      .resizable()
                    
                    Rectangle()
                        .fill(Color.clear)
                        .background {
                            Rectangle()
                                .fill(.ultraThinMaterial.opacity(0.6))
                                .shadow(color: Color.black.opacity(0.1),
                                        radius: 5, x: 5, y: 5)
                        }
                        .modifier(CornerRectangleModifier(topLeft: 6, topRight: 49, bottom: 29))
                        .padding(EdgeInsets(top: 89, leading: 28, bottom: 40, trailing: 29))
  
                    Image("ShareWhite3")
                        .resizable()

                    selectShareData
                        .padding(.top, 44)
                    
                    if !viewModel.runningData.userLocations.isEmpty {
                        ZStack {
                            Color.black.opacity(0.001)
                            userPath
                        }
                        .frame(width: pathWidth + 30, height: pathHeight + 30)
                        .scaleEffect(scale)
                        .offset(offset)
                        .rotationEffect(lastAngle + angle)
                        .gesture(dragGesture)
                        .gesture(rotationGesture)
                        .simultaneousGesture(magnificationGesture)
                    }
                }
            )
        } else {
            AnyView(
                Button {
                    showSheet = true
                } label: {
                    Image("ShareSelect")
                        .resizable()
                }
            )
        }
    }
    
    private var selectShareData: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.runningData.distance)
                .font(.shareData)
                .fontWeight(.bold)
                .padding(.bottom, 17)
            
            Text(viewModel.runningData.pace)
                .font(.shareData)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 16)
    }
    
}
extension ImageShareView {
    private var blackImageView: some View {
        ZStack {
            Image("ShareBlack")
                .resizable()
            
            blackShareData
                .padding(.top, 166)
                .padding(.leading, 8)
            
            if !viewModel.runningData.userLocations.isEmpty {
                ZStack {
                    Color.black.opacity(0.001)
                    userPath
                }
                .frame(width: pathWidth + 30, height: pathHeight + 30)
                .scaleEffect(scale)
                .offset(offset)
                .rotationEffect(lastAngle + angle)
                .gesture(dragGesture)
                .gesture(rotationGesture)
                .simultaneousGesture(magnificationGesture)
            }
        }
    }
    
    private var blackShareData: some View {
        VStack(alignment: .leading) {
            Text(viewModel.runningData.courseName)
                .font(.shareTitle)
            Text(viewModel.runningData.runningRegion)
                .font(.tab)
                .padding(.bottom, 32)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Distance \(viewModel.runningData.distance)")
                    Text("Pace \(viewModel.runningData.pace)")
                }
                .padding(.trailing, 28)
                
                VStack(alignment: .leading) {
                    Text(viewModel.runningData.cal)
                    Text(viewModel.runningData.bpm)
                }
                .padding(.trailing, 25)
                
                VStack(alignment: .leading) {
                    Text(viewModel.runningData.runningDate)
                    Text(viewModel.runningData.time)
                }
            }
            .font(.tab)
            .padding(.trailing, 5)
        }
    }
}

extension ImageShareView {
    private var pageIndicator: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.customWhite)
                .frame(width: 25, height: 3)
                .padding(.trailing, 5)
            
            Rectangle()
                .fill(Color.customPrimary)
                .frame(width: 25, height: 3)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 168)
        .padding(.bottom, 32)
    }
    
    private var selectModeView: some View {
        HStack(spacing: 0) {
            Button {
                selectPhotoMode = false
            } label: {
                Circle()
                    .fill(.black)
                    .stroke(selectPhotoMode ?  Color.gray200 : Color.customPrimary, lineWidth: 5)
            }
            .padding(.horizontal, 12)
            
            Button {
                selectPhotoMode = true
            } label: {
                Circle()
                    .fill(.white)
                    .stroke(selectPhotoMode ? Color.customPrimary : Color.gray200, lineWidth: 5)
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 143)
        .padding(.bottom, 110)
    }
}

extension ImageShareView {
    private var userPath: some View {
        PathGenerateManager
            .caculateLines(width: imageSize, height: imageSize, coordinates: viewModel.runningData.userLocations)
            .stroke(lineWidth: 5)
            .scale(0.5)
            .foregroundStyle(selectPhotoMode ? Color.customPrimary : Color.customWhite)
    }
    
    private var dragGesture: some Gesture {
        return DragGesture()
            .onChanged { value in
                let rotationRadians = lastAngle.radians
                let x1 = value.translation.width * cos(rotationRadians)
                let x2 = value.translation.height * -sin(rotationRadians)
                let y1 =  value.translation.width * -sin(rotationRadians)
                let y2 = value.translation.height * cos(rotationRadians)
                
                let translatedX = x1 - x2
                let translatedY = y1 + y2

                offset = CGSize(width: translatedX, height: translatedY)
            }
            .onEnded { _ in
                lastStoredOffset = offset
            }
    }
    
    private var rotationGesture: some Gesture {
        return RotationGesture()
            .onChanged { value in
                angle = value
            }
             .onEnded { _ in
                 withAnimation(.spring) {
                     lastAngle += angle
                     angle = .zero
                 }
             }
    }
    
    private var magnificationGesture: some Gesture {
        return MagnificationGesture()
            .onChanged { value in
                let updatedScale = value + lastScale
                scale = (updatedScale < 1 ? 1 : updatedScale)
            }
            .onEnded { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    if scale < 1 {
                        scale = 1
                        lastScale = 0
                    } else {
                        lastScale = scale-1
                    }
                }
            }
    }
}

struct SheetModifier: ViewModifier {
    
    @ObservedObject var viewModel: ShareViewModel
    @Binding var showSheet: Bool
    @Binding var image: UIImage?
    
    func body(content: Content) -> some View {
        content
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
