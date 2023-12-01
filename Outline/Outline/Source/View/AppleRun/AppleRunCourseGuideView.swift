//
//  AppleRunCourseGuideView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import MapKit
import SwiftUI

struct AppleRunCourseGuideView: View {
    @StateObject private var appleRunManager = AppleRunManager.shared
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
                ZStack {
                    AppleRunGuide()
                        .stroke(.customBlack.opacity(0.5), style: .init(lineWidth: tapGuideView ? 5 : 7, lineCap: .round, lineJoin: .round))
                    AppleRunGuide()
                        .trim(from: 0.0, to: appleRunManager.progress)
                        .stroke(.customPrimary, style: .init(lineWidth: tapGuideView ? 5 : 7, lineCap: .round, lineJoin: .round))
                        .animation(.smooth, value: appleRunManager.progress)
                }
                .frame(width: 80, height: 100)
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
        path.move(to: CGPoint(x: 0.48462*width, y: 0.38903*height))
        path.addCurve(to: CGPoint(x: 0.15424*width, y: 0.36509*height), control1: CGPoint(x: 0.48462*width, y: 0.38903*height), control2: CGPoint(x: 0.29014*width, y: 0.27582*height))
        path.addCurve(to: CGPoint(x: 0.14193*width, y: 0.84187*height), control1: CGPoint(x: 0.01845*width, y: 0.45435*height), control2: CGPoint(x: -0.0495*width, y: 0.65031*height))
        path.addCurve(to: CGPoint(x: 0.40132*width, y: 0.9659*height), control1: CGPoint(x: 0.33337*width, y: 1.03343*height), control2: CGPoint(x: 0.40132*width, y: 0.9659*height))
        path.addCurve(to: CGPoint(x: 0.57022*width, y: 0.9674*height), control1: CGPoint(x: 0.40132*width, y: 0.9659*height), control2: CGPoint(x: 0.4733*width, y: 0.92207*height))
        path.addCurve(to: CGPoint(x: 0.67965*width, y: 0.97074*height), control1: CGPoint(x: 0.57022*width, y: 0.9674*height), control2: CGPoint(x: 0.62107*width, y: 0.99037*height))
        path.addCurve(to: CGPoint(x: 0.90713*width, y: 0.7901*height), control1: CGPoint(x: 0.73824*width, y: 0.95111*height), control2: CGPoint(x: 0.8639*width, y: 0.86924*height))
        path.addCurve(to: CGPoint(x: 0.89897*width, y: 0.39828*height), control1: CGPoint(x: 0.95036*width, y: 0.71096*height), control2: CGPoint(x: 1.03934*width, y: 0.5658*height))
        path.addCurve(to: CGPoint(x: 0.65505*width, y: 0.33595*height), control1: CGPoint(x: 0.89897*width, y: 0.39828*height), control2: CGPoint(x: 0.81719*width, y: 0.30989*height))
        path.addCurve(to: CGPoint(x: 0.5676*width, y: 0.34202*height), control1: CGPoint(x: 0.65505*width, y: 0.33595*height), control2: CGPoint(x: 0.59047*width, y: 0.35761*height))
        path.addCurve(to: CGPoint(x: 0.55366*width, y: 0.11024*height), control1: CGPoint(x: 0.54473*width, y: 0.32644*height), control2: CGPoint(x: 0.45718*width, y: 0.2311*height))
        path.addCurve(to: CGPoint(x: 0.74455*width, y: 0.02555*height), control1: CGPoint(x: 0.65014*width, y: -0.01063*height), control2: CGPoint(x: 0.74455*width, y: 0.02555*height))
        path.addCurve(to: CGPoint(x: 0.72713*width, y: 0.12062*height), control1: CGPoint(x: 0.74455*width, y: 0.02555*height), control2: CGPoint(x: 0.80205*width, y: 0.03673*height))
        path.addCurve(to: CGPoint(x: 0.52775*width, y: 0.2503*height), control1: CGPoint(x: 0.65221*width, y: 0.20443*height), control2: CGPoint(x: 0.52775*width, y: 0.2503*height))
        return path
    }
}

#Preview {
    AppleRunView()
}
