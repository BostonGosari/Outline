//
//  SharePhotoView.swift
//  Outline
//
//  Created by Seungui Moon on 11/22/23.
//

import CoreLocation
import Photos
import SwiftUI

struct SharePhotoView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ShareViewModel()

    @State private var size: CGSize = .zero
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @State private var angle: Angle = .degrees(0)
    @State private var lastAngle: Angle = .degrees(0)
    
    @State private var pathWidth: CGFloat = 0
    @State private var pathHeight: CGFloat = 0
    
    @State private var image: UIImage?
    
    @State private var showUploadSheet = false
    @State private var showCamera = false
    @State private var showImagePicker = false
    @State private var permissionDenied = false
    @State private var photoImage: UIImage?
    
    let runningData: ShareModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 30)
                        shareImageCombined
                        buttons
                    }
                
            }
            .navigationTitle("공유")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("공유") {
                        renderShareView()
                        if let img = image {
                            viewModel.shareToInstagram(image: img)
                        }
                    }
                }
            }
            .toolbarBackground(Color.gray900)
            
        }
        .onAppear {
            let canvasSize = PathGenerateManager.calculateCanvaData(coordinates: runningData.userLocations, width: 200, height: 200)
            pathWidth = CGFloat(canvasSize.width)
            pathHeight = CGFloat(canvasSize.height)
            renderShareView()
        }
        .actionSheet(isPresented: $showUploadSheet) {
               ActionSheet(
                title: Text("이미지 선택"),
                buttons: [
                    .default(Text("사진 찍기"), action: {
                        showCamera = true
                    }),
                    .default(Text("이미지 선택"), action: {
                        showImagePicker = true
                    }),
                    .cancel(Text("Cancel"), action: {
                        showUploadSheet = false
                    })
                ])
           }
        .fullScreenCover(isPresented: $showCamera) {
            ImagePickerView(selectedImage: $photoImage, sourceType: .camera)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $photoImage)
        }
        .sheet(isPresented: $viewModel.permissionDenied) {
            PermissionSheet(permissionType: .photoLibrary)
        }
        .sheet(isPresented: $viewModel.isShowInstaAlert) {
            instaSheet
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: "이미지 저장이 완료되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

extension SharePhotoView {
    private var viewForShare: some View {
        ZStack {
            if let uiImage = photoImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
            }
            ZStack {
                Image("ShareFirstLayer")
                Image("ShareSecondLayer")
//                    .background(
//                        TransparentBlurView(removeAllFilters: true)
//                            .blur(radius: 0, opaque: true)
//                    )
                Image("ShareThirdLayer")
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            .frame(width: size.width, height: size.height)
            
            ZStack {
                VStack(alignment: .trailing, spacing: -3) {
                    Text("Time \(runningData.time)")
                    Text("Pace \(runningData.pace)")
                    Text("Distance \(runningData.distance)")
                    Text("Kcal \(runningData.cal)")
                }
                .font(.customSubbody)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 8)
            .frame(width: size.width, height: size.height)

            userPath
        }
        .frame(width: size.width, height: size.height)
        .background(.white.opacity(0))
    }
    private var shareImageCombined: some View {
        ZStack {
            if let uiImage = photoImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width + 30, height: size.height + 30)
//                    .mask {
//                        Rectangle()
//                            .aspectRatio(1080.0/1920.0, contentMode: .fit)
//                    }
            }
            shareImage
            runningInfo
            userPath
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        size = CGSize(width: proxy.size.width - 30, height: proxy.size.height - 70)
                    }
            }
        }
        .aspectRatio(1080.0/1920.0, contentMode: .fit)
        .frame(maxWidth: size.width, maxHeight: size.height - 60)
    }
    
    private var shareImage: some View {
        ZStack {
            backgroundImage
            runningInfo
        }
        .background(.clear)
    }
    
    private var backgroundImage: some View {
        ZStack {
            Image("ShareFirstLayer")
            Image("ShareSecondLayer")
//                .background(
//                    TransparentBlurView(removeAllFilters: true)
//                        .blur(radius: 1, opaque: true)
//                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            Image("ShareThirdLayer")
        }
        .padding(.top, 16)
        .padding(.bottom, 46)
        .background(.clear)
    }
    
    private var runningInfo: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: -3) {
                Text("Time \(runningData.time)")
                Text("Pace \(runningData.pace)")
                Text("Distance \(runningData.distance)")
                Text("Kcal \(runningData.cal)")
            }
            .font(.customSubbody)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .padding(.trailing, 50)
        .padding(.bottom, 55)
        .background(.clear)
    }
    
    private var userPath: some View {
        ZStack {
            Color.black.opacity(0.001)
            PathGenerateManager
                .caculateLines(width: 200, height: 200, coordinates: runningData.userLocations)
                .stroke(.customPrimary, style: .init(lineWidth: 5, lineCap: .round, lineJoin: .round))
        }
        .frame(width: pathWidth + 30, height: pathHeight + 30)
        .scaleEffect(scale)
        .offset(offset)
        .rotationEffect(lastAngle + angle)
        .gesture(dragGesture)
        .gesture(rotationGesture)
        .simultaneousGesture(magnificationGesture)
    }
    
    private var buttons: some View {
        HStack(spacing: 0) {
            Button {
                renderShareView()
                if let img = image {
                    viewModel.saveImage(image: img)
                }
                
            } label: {
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
            
            CompleteButton(text: "사진 업로드하기", isActive: true) {
                showUploadSheet = true
//                renderShareView()
//                if let img = image {
//                    viewModel.shareToInstagram(image: img)
//                }
            }
            .padding(.leading, -8)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private var instaSheet: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(lineWidth: 2)
                .foregroundStyle(Gradient(colors: [.customPrimary, .gray900, .gray900, .gray900]))
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Instagram 설치")
                    .font(.customTitle2)
                    .fontWeight(.semibold)
                    .padding(.top, 36)
                Text("Instagram을 설치해야 아트를 공유할 수 있어요.")
                    .font(.customSubbody)
                    .foregroundColor(.gray300)
                    .multilineTextAlignment(.center)
                Image("InstaImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .padding(.bottom, 32)
                Button {
                    viewModel.isShowInstaAlert = false
                } label: {
                    Text("확인")
                        .font(.customButton)
                        .foregroundStyle(Color.customBlack)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color.customPrimary)
                        }
                }
                .padding()
            }
            .presentationDetents([.height(400)])
            .presentationCornerRadius(35)
        }
    }
}

extension SharePhotoView {
    
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

extension SharePhotoView {
    private func renderShareView() {
        image = viewForShare.offset(y: -24).asImage(size: size)
    }
    
    private func renderShareViewWithRenderer() {
        let renderer = ImageRenderer(content: shareImageCombined)
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = true
        
        if let cgImage = renderer.cgImage {
            image = UIImage(cgImage: cgImage)
        }
    }
    
}

extension SharePhotoView {
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.showCamera = true
            } else {
//                self.alertTitle = "카메라 권한 허용"
//                self.alertMessage = "권한을 허용하면 사진을 찍어 업로드할 수 있어요."
//                self.imageName = "icon_Image_B"
                self.permissionDenied = true
            }
        }
    }
    
    func checkAlbumPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.showImagePicker = true
            case .denied:
//                self.alertTitle = "사진 권한 허용"
//                self.alertMessage = "권한을 허용하면 사진을 함께 업로드할 수 있어요."
//                self.imageName = "icon_Camera"
                self.permissionDenied = true
            case .restricted, .notDetermined:
//                self.alertTitle = "사진 권한 허용"
//                self.alertMessage = "권한을 허용하면 사진을 함께 업로드할 수 있어요."
//                self.imageName = "icon_Camera"
                self.permissionDenied = true
            default:
                break
            }
        }
    }
}
