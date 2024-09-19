//
//  ShareView+Extension.swift
//  Outline
//
//  Created by Seungui Moon on 3/4/24.
//

import CoreLocation
import SwiftUI

extension ShareView {
    var firstShareView: some View {
        ZStack {
            backgroundImage
            
            Image("ShareCardImage")
                .overlay(alignment: .bottom) {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("TIME")
                                .font(.caption)
                                .foregroundColor(.gray300)
                            Text(runningData.time)
                                .font(.customSubbody)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("DISTANCE")
                                .font(.caption)
                                .foregroundColor(.gray300)
                            Text(runningData.distance)
                                .font(.customSubbody)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }
                .overlay {
                    userPath
                }
            
            Text("OUTLINE")
                .font(.customShareOutlineBottom)
                .foregroundStyle(.white)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 20)
        }
        .background {
            renderSizeView
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 16)
    }

    var secondShareView: some View {
        ShareMapView(userLocations: runningData.userLocations)
            .overlay {
                runningInfo
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
    }
    
    var thirdShareView: some View {
        ZStack {
            backgroundImage
            
            userPath
                .overlay {
                    runningInfo
                }
        }
        .background {
            renderSizeView
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 16)
    }
    
    var fourthShareView: some View {
        ZStack {
            backgroundImage
            
            VStack(spacing: 8) {
                ShareMapView(userLocations: runningData.userLocations)
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .topLeading) {
                        Text("OUTLINE")
                            .font(.customShareOutlineTop)
                            .padding(8)
                    }
                
                HStack(spacing: 24) {
                    Text("TIME \(runningData.time)")
                        .font(.customShareFourth)
                    
                    Text("DISTANCE \(runningData.distance)")
                        .font(.customShareFourth)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 100)
        }
        .background {
            renderSizeView
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 16)
    }
}

extension ShareView {
    var userPath: some View {
        ZStack {
            Color.black.opacity(0.001)
            PathManager
                .createPath(width: 150, height: 150, coordinates: runningData.userLocations)
                .stroke(.customPrimary, style: .init(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: canvasData.width, height: canvasData.height)
        }
        .scaleEffect(viewModel.scale)
        .offset(viewModel.offset)
        .rotationEffect(viewModel.lastAngle + viewModel.angle)
        .gesture(dragGesture)
        .gesture(rotationGesture)
        .simultaneousGesture(magnificationGesture)
    }
    
    var backgroundImage: some View {
        ZStack {
            if let image = viewModel.uploadedImage {
                Rectangle()
                    .fill(.clear)
                    .overlay {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: viewModel.size.width, height: viewModel.size.height)
                    }
            } else {
                Rectangle()
                    .fill(Color.black)
                    .aspectRatio(9/16, contentMode: .fill)
            }
        }
    }
    
    @ViewBuilder
    func mapImage(image: UIImage?) -> some View {
        ZStack {
            if let img = image {
                Image(uiImage: img)
            } else {
                Rectangle()
                    .fill(.black)
            }
        }
    }
    
    var renderSizeView: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    if !viewModel.isSizeFixed {
                        viewModel.onAppearSharedImageCombined(size: proxy.size)
                        viewModel.isSizeFixed = true
                    }
                }
                .onChange(of: viewModel.uploadedImage) {
                    let adjustedSize = CGSize(width: proxy.size.width + 80, height: proxy.size.height + 32)
                    
                    viewModel.onAppearSharedImageCombined(size: adjustedSize)
                }
        }
    }
    
    var runningInfo: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    TextField("", text: $viewModel.currentCourseName, axis: .vertical)
                        .font(.customShareSecondTitle)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .onChange(of: viewModel.currentCourseName) { _, newValue in
                            if newValue.contains("\n") {
                                viewModel.currentCourseName = newValue.replacingOccurrences(of: "\n", with: "")
                                isFocused = false
                            } else if newValue.count > 10 {
                                viewModel.currentCourseName = String(newValue.prefix(10))
                            } else {
                                viewModel.currentCourseName = newValue
                            }
                        }
                        .focused($isFocused)
                    
                    Text(runningData.runningDate)
                        .font(.customShareSecondTime)
                }
                
                Spacer(minLength: 16)
                
                VStack(alignment: .trailing) {
                    Text("DISTANCE")
                    Text(runningData.distance)
                    Text("TIME")
                    Text(runningData.time)
                }
                .font(.customShareSecondInfo)
            }
            .padding(.top, 75)
            
            Text("OUTLINE")
                .font(.customShareOutlineBottom)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 36)
        .foregroundStyle(.white)
    }
    
    var renderRunningInfo: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .leading) {
                    Text(viewModel.currentCourseName)
                        .font(.customShareSecondTitle)
                        .lineLimit(2)
                    
                    Text(runningData.runningDate)
                        .font(.customShareSecondTime)
                }
                
                Spacer(minLength: 40)
                
                VStack(alignment: .trailing) {
                    Text("DISTANCE")
                    Text(runningData.distance)
                    Text("TIME")
                    Text(runningData.time)
                }
                .font(.customShareSecondInfo)
                
                Spacer()
            }
            .padding(.top, 75)
            
            Text("OUTLINE")
                .font(.customShareOutlineBottom)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 20)
        }
        .foregroundStyle(.white)
    }
}

extension ShareView {
    @ViewBuilder
    func renderSecondShareView(_ image: UIImage?) -> some View {
        mapImage(image: image)
            .overlay {
                renderRunningInfo
                    .padding(.horizontal, 16)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
    }
    
    @ViewBuilder
    func renderThirdShareView() -> some View {
        ZStack {
            backgroundImage
            
            userPath
                .overlay {
                    renderRunningInfo
                        .padding(.horizontal, 8)
                }
        }
        .background {
            renderSizeView
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    func renderFourthShareView(_ image: UIImage?) -> some View {
        ZStack {
            backgroundImage
            
            VStack(spacing: 8) {
                mapImage(image: image)
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .topLeading) {
                        Text("OUTLINE")
                            .font(.customShareOutlineTop)
                            .padding(8)
                    }
                
                HStack(spacing: 24) {
                    Text("TIME \(runningData.time)")
                        .font(.customShareFourth)
                    
                    Text("DISTANCE \(runningData.distance)")
                        .font(.customShareFourth)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .foregroundStyle(.white)
            .padding(.top, 100)
        }
        .background {
            renderSizeView
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 16)
    }
}

extension ShareView {
    var tabButtons: some View {
        HStack {
            ForEach(0..<4) { index in
                Button {
                    withAnimation {
                        currentShareView = index
                    }
                } label: {
                    Rectangle()
                        .frame(width: indexWidth, height: indexHeight)
                        .foregroundStyle(currentShareView == index ? .customPrimary : .white)
                        .padding(.vertical, 10)
                        .background(Color.clear)
                }
            }
        }
    }
    
    var buttons: some View {
        HStack(spacing: 0) {
            Button {
                selecteRenderView(isSave: true)
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
            
            CompleteButton(text: "사진 업로드하기", isActive: currentShareView != 1) {
                viewModel.isShowUploadImageSheet = true
            }
            .padding(.leading, -8)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 72)
    }
    
    var instaSheet: some View {
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

extension ShareView {
    var dragGesture: some Gesture {
        return DragGesture()
            .onChanged { value in
                let rotationRadians = viewModel.lastAngle.radians
                let x1 = value.translation.width * cos(rotationRadians)
                let x2 = value.translation.height * -sin(rotationRadians)
                let y1 =  value.translation.width * -sin(rotationRadians)
                let y2 = value.translation.height * cos(rotationRadians)
                
                let translatedX = x1 - x2
                let translatedY = y1 + y2

                viewModel.offset = CGSize(width: translatedX, height: translatedY)
            }
            .onEnded { _ in
                viewModel.lastStoredOffset = viewModel.offset
            }
    }
    
    var rotationGesture: some Gesture {
        return RotationGesture()
            .onChanged { value in
                viewModel.angle = value
            }
             .onEnded { _ in
                 withAnimation(.spring) {
                     viewModel.lastAngle += viewModel.angle
                     viewModel.angle = .zero
                 }
             }
    }
    
    var magnificationGesture: some Gesture {
        return MagnificationGesture()
            .onChanged { value in
                let updatedScale = value + viewModel.lastScale
                viewModel.scale = (updatedScale < 1 ? 1 : updatedScale)
            }
            .onEnded { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    if viewModel.scale < 1 {
                        viewModel.scale = 1
                        viewModel.lastScale = 0
                    } else {
                        viewModel.lastScale = viewModel.scale - 1
                    }
                }
            }
    }
}

extension View {
    @MainActor func render(scale: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale
        return renderer.uiImage
    }
}

#Preview {
    ShareView(runningData: ShareModel(courseName: "Whale Run.", runningDate: "2023.11.12", distance: "1.2km", time: "00:20", userLocations: []))
}
