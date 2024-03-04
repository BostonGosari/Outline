//
//  ShareView+.swift
//  Outline
//
//  Created by Seungui Moon on 3/4/24.
//

import CoreLocation
import SwiftUI

extension ShareView {
    var shareImageCombined: some View {
        ZStack {
            backgroundImage
            runningInfo
            userPath
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        size = CGSize(width: proxy.size.width - 30, height: proxy.size.height - 70)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var backgroundImage: some View {
        ZStack {
            Image("ShareFirstLayer")
            Image("ShareSecondLayer")
                .background(
                    Rectangle()
                        .fill(.white30)
                        .blur(radius: 3)
                        .mask(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70))
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            Image("ShareThirdLayer")
        }
        .padding(.top, 16)
        .padding(.bottom, 46)
    }
    
    var runningInfo: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: -4) {
                Text("Time \(runningData.time)")
                Text("Pace \(runningData.pace)")
                Text("Distance \(runningData.distance)")
                Text("Kcal \(runningData.cal)")
            }
            .font(.customSubbody)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .padding(.trailing, 32)
        .padding(.bottom, 55)
    }
    
    var userPath: some View {
        ZStack {
            Color.black.opacity(0.001)
            PathManager
                .createPath(width: 200, height: 200, coordinates: runningData.userLocations)
                .stroke(.customPrimary, style: .init(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: canvasData.width, height: canvasData.height)
        }
        .scaleEffect(scale)
        .offset(offset)
        .rotationEffect(lastAngle + angle)
        .gesture(dragGesture)
        .gesture(rotationGesture)
        .simultaneousGesture(magnificationGesture)
    }
    
    var buttons: some View {
        HStack(spacing: 0) {
            Button {
                renderShareView(true)
                if let img = image {
                    DispatchQueue.main.async {
                        viewModel.saveImage(image: img)
                    }
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
                renderShareView(false)
                if let img = image {
                    viewModel.shareToInstagram(image: img)
                }
                
            }
            .padding(.leading, -8)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 70)
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
    func renderShareView(_ isSave: Bool) {
        image = shareImageCombined
            .background(isSave ? .gray900 : .clear)
            .render(scale: 3)
    }
}

extension ShareView {
    var dragGesture: some Gesture {
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
    
    var rotationGesture: some Gesture {
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
    
    var magnificationGesture: some Gesture {
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

extension View {
    @MainActor func render(scale: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale
        return renderer.uiImage
    }
}
