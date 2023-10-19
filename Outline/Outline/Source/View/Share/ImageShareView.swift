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
    
    private let gradientColors = [
        Color.white,
        Color.white.opacity(0.1),
        Color.white.opacity(0.1),
        Color.white.opacity(0.4),
        Color.white.opacity(0.5)
    ]
    
    private let pathManager = PathGenerateManager.shared
    
    var body: some View {
        ZStack {
            Color.gray900Color
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                GeometryReader { geo in
                    ZStack {
                        if selectPhotoMode {
                            selectPhotoView
                        } else {
                            blackImageView
                        }
                    }
                    .aspectRatio(1080/1920, contentMode: .fit)
                    .padding(EdgeInsets(top: 20, leading: 49, bottom: 16, trailing: 49))
                    .onAppear {
                        self.size = CGSize(width: geo.size.width-98, height: geo.size.height-36)
                    }
                    .mask {
                        Rectangle()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .aspectRatio(1080.0/1920.0, contentMode: .fit)
                    }
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
    }
}

extension ImageShareView {
    private var selectPhotoView: AnyView {
        if let img = image {
            AnyView(
                ZStack {
                    Image(uiImage: img)
                        .resizable()
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
                        .padding(.top, 43)
                    
                    userPath
                        .scaleEffect(scale)
                        .offset(offset)
                        .rotationEffect(angle)
                }
                .gesture(dragGesture)
                .gesture(rotationGesture)
                .simultaneousGesture(magnificationGesture)
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
                .padding(.bottom, 14)
            
            Text(viewModel.runningData.pace)
                .font(.shareData)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 18)
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
            
            userPath
                .scaleEffect(scale)
                .offset(offset)
                .rotationEffect(angle)
        }
        .gesture(dragGesture)
        .gesture(rotationGesture)
        .simultaneousGesture(magnificationGesture)
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
                selectPhotoMode = false
            } label: {
                Circle()
                    .fill(.black)
                    .stroke(selectPhotoMode ?  Color.gray200Color : Color.primaryColor, lineWidth: 5)
            }
            .padding(.horizontal, 12)
            
            Button {
                selectPhotoMode = true
            } label: {
                Circle()
                    .fill(.white)
                    .stroke(selectPhotoMode ? Color.primaryColor : Color.gray200Color, lineWidth: 5)
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
        pathManager
            .caculateLines(width: size.width, height: size.height, coordinates: viewModel.runningData.userLocations)
            .stroke(lineWidth: 5)
            .scale(0.5)
            .foregroundStyle(selectPhotoMode ? Color.primaryColor : Color.white)
    }
    
    private var dragGesture: some Gesture {
        return DragGesture()
            .onChanged { value in
                let translation = value.translation
                offset = CGSize(
                    width: translation.width+lastStoredOffset.width,
                    height: translation.height+lastStoredOffset.height
                )
            }
            .onEnded { _ in
                lastStoredOffset = offset
            }
    }
    
    private var rotationGesture: some Gesture {
        return RotationGesture()
            .onChanged { value in
                angle = lastAngle+value
            }
         .onEnded { _ in
             withAnimation(.spring) {
                 lastAngle = angle
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
