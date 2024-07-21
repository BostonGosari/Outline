//
//  CourseGuideView.swift
//  Outline
//
//  Created by hyebin on 10/25/23.
//

import CoreLocation
import SwiftUI

struct CourseGuideView: View {
    @Binding var tapGuideView: Bool
    
    let coursePathCoordinates: [CLLocationCoordinate2D]
    let courseRotate: Double
    var userLocations: [CLLocationCoordinate2D]
    var tapPossible: Bool
    
    private let width = 113.0
    private let height = 168.0
    
    private var canvasData: CanvasData {
        return PathManager.getCanvasData(coordinates: coursePathCoordinates, width: width, height: height)
    }
    
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
            }
            .frame(width: canvasData.width, height: canvasData.height)
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
}

extension CourseGuideView {
    private var coursePath: some View {
        PathManager
            .createPath(width: width, height: height, coordinates: coursePathCoordinates)
            .stroke(.customBlack.opacity(0.5), style: .init(lineWidth: tapGuideView ? 3 : 4, lineCap: .round, lineJoin: .round))
            .scaleEffect(0.8)
    }
    
    private var userPath: some View {
        PathManager
            .createPath(width: width, height: height, coordinates: userLocations, canvasData: canvasData)
            .stroke(.customPrimary, style: .init(lineWidth: tapGuideView ? 3 : 4, lineCap: .round, lineJoin: .round))
            .scaleEffect(0.8)
    }
}
