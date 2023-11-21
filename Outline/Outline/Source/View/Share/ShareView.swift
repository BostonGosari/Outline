//
//  ShareView.swift
//  Outline
//
//  Created by hyebin on 11/21/23.
//

import CoreLocation
import SwiftUI

struct ShareView: View {
    @Environment(\.dismiss) var dismiss

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @State private var angle: Angle = .degrees(0)
    @State private var lastAngle: Angle = .degrees(0)
    
    @State private var pathWidth: CGFloat = 0
    @State private var pathHeight: CGFloat = 0
    
    let runningData: ShareModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack {
                        ZStack {
                            Image("ShareFirstLayer")
                            Image("ShareSecondLayer")
                            Image("ShareThirdLayer")
                        }
                            .padding(.top, 16)
                            .padding(.bottom, 46)
                        
                        VStack(alignment: .trailing) {
                            Text("Time 00:20")
                            Text("Pace 9'99\"")
                            Text("Distance 1.2km")
                            Text("Kcal 235")
                        }
                        .font(.customSubbody)
                        .lineSpacing(16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.trailing, 50)
                        .padding(.bottom, 46)
                        
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
                    
                    HStack(spacing: 0) {
                        Button {
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
                        
                        CompleteButton(text: "Instagram으로 공유하기", isActive: true) {
                        }
                        .padding(.leading, -8)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .navigationTitle("공유")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        (Text(Image(systemName: "chevron.left")) + Text("뒤로"))
                            .foregroundStyle(Color.customPrimary)
                    }
                }
            }
        }
    }
}
extension ShareView {
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

#Preview {
    ShareView(runningData: ShareModel(courseName: "고래런", runningDate: "2023.11.21", regionDisplayName: "포항시 지곡동", distance: "32.2km", cal: "235", pace: "9'99\"", bpm: "--", time: "00:20", userLocations: []))
}
