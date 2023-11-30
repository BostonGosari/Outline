//
//  AppleRunCourseGuideView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import MapKit
import SwiftUI

struct AppleRunCourseGuideView: View {
    @Binding var tapGuideView: Bool
    
    let coursePathCoordinates: [CLLocationCoordinate2D]
    let courseRotate: Double
    var userLocations: [CLLocationCoordinate2D]
    var tapPossible: Bool
    
    var width = 113.0
    var height = 168.0

    var body: some View {
        ZStack {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 3, opaque: true)
                .overlay(
                    Rectangle()
                        .fill(Color.white30)
                        .roundedCorners(20, corners: [.bottomRight])
                        .roundedCorners(7, corners: [.topLeft, .topRight, .bottomLeft])
                )
            ZStack {
                coursePath
                userPath
                VStack {
                    Ellipse()
                        .frame(width: 24, height: 12)
                        .rotationEffect(.degrees(-32))
                        .foregroundStyle(.customPrimary)
                    AppleRunGuide()
                        .stroke(.customBlack.opacity(0.5), style: .init(lineWidth: 7, lineCap: .round, lineJoin: .round))
                        .scaledToFit()
                }
                .frame(width: 100, height: 100)
            }
            .rotationEffect(Angle(degrees: courseRotate))
        }
        .overlay {
            UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 7, bottomTrailingRadius: 20, topTrailingRadius: 7)
                .strokeBorder(.white, lineWidth: tapGuideView ? 0.7 : 2)
        }
        .mask {
            UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 7, bottomTrailingRadius: 20, topTrailingRadius: 7)
        }
        .frame(width: width, height: height)
        .scaleEffect(tapGuideView ? 3 : 1, anchor: .top)
        .onTapGesture {
            if tapPossible {
                withAnimation {
                    tapGuideView.toggle()
                }
                HapticManager.impact(style: .light)
            }
        }
    }
    
    private var coursePath: some View {
        PathGenerateManager
            .caculateLines(width: width, height: height, coordinates: coursePathCoordinates)
            .stroke(.customBlack.opacity(0.5), style: .init(lineWidth: 7, lineCap: .round, lineJoin: .round))
            .scaleEffect(0.8)
    }
    
    private var userPath: some View {
        let canvasData = PathGenerateManager.calculateCanvaData(coordinates: coursePathCoordinates, width: width, height: height)
        
        return PathGenerateManager
            .caculateLines(width: width, height: height, coordinates: userLocations, canvasData: canvasData)
            .stroke(.customPrimary, style: .init(lineWidth: 7, lineCap: .round, lineJoin: .round))
            .scaleEffect(0.8)
    }
}

struct AppleRunGuide: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.21326*width, y: 0.11764*height))
        path.addCurve(to: CGPoint(x: 0.78628*width, y: 0.15988*height), control1: CGPoint(x: 0.31942*width, y: 0.03692*height), control2: CGPoint(x: 0.49819*width, y: 0.00758*height))
        path.addCurve(to: CGPoint(x: 0.69867*width, y: 0.32223*height), control1: CGPoint(x: 0.74389*width, y: 0.22351*height), control2: CGPoint(x: 0.71477*width, y: 0.27705*height))
        path.addCurve(to: CGPoint(x: 0.70707*width, y: 0.47861*height), control1: CGPoint(x: 0.6788*width, y: 0.37802*height), control2: CGPoint(x: 0.67458*width, y: 0.43417*height))
        path.addCurve(to: CGPoint(x: 0.83137*width, y: 0.5411*height), control1: CGPoint(x: 0.73648*width, y: 0.51882*height), control2: CGPoint(x: 0.78587*width, y: 0.53383*height))
        path.addCurve(to: CGPoint(x: 0.94893*width, y: 0.54944*height), control1: CGPoint(x: 0.86588*width, y: 0.54661*height), control2: CGPoint(x: 0.90595*width, y: 0.5487*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.94872*height), control1: CGPoint(x: 0.92364*width, y: 0.77193*height), control2: CGPoint(x: 0.73461*width, y: 0.94872*height))
        path.addCurve(to: CGPoint(x: 0.04819*width, y: 0.49853*height), control1: CGPoint(x: 0.24775*width, y: 0.94872*height), control2: CGPoint(x: 0.04819*width, y: 0.74435*height))
        path.addCurve(to: CGPoint(x: 0.21326*width, y: 0.11764*height), control1: CGPoint(x: 0.04819*width, y: 0.36997*height), control2: CGPoint(x: 0.09698*width, y: 0.20606*height))
        path.closeSubpath()
        return path
    }
}

