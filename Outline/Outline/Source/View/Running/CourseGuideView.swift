//
//  CourseGuideView.swift
//  Outline
//
//  Created by hyebin on 10/25/23.
//

import CoreLocation
import SwiftUI

struct CourseGuideView: View {
    @Binding var showBigGuide: Bool
    
    let coursePathCoordinates: [CLLocationCoordinate2D]
    let courseRotate: Double
    var userLocations: [CLLocationCoordinate2D]
    
    var width: Double {
        return showBigGuide ? 320 : 113
    }
    
    var height: Double {
        return showBigGuide ? 480 : 168
    }
    
    var body: some View {
        ZStack(alignment: showBigGuide ? .top : .topTrailing) {
            if showBigGuide {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
            }
            
            Rectangle()
                .fill(Color.white30)
                .roundedCorners(24.5, corners: [.topRight])
                .roundedCorners(7, corners: [.topLeft, .bottomLeft, .bottomRight])
                .overlay(
                    CustomRoundedRectangle(cornerRadiusTopLeft: 7, cornerRadiusTopRight: 24.5, cornerRadiusBottomLeft: 7, cornerRadiusBottomRight: 7)
                )
                .overlay {
                    coursePath
                        .overlay {
                            userPath
                        }
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: courseRotate))
                        .frame(width: width, height: height, alignment: .center)
                }
                .frame(width: width, height: height)
                .padding(.top, showBigGuide ? 100 : 16)
                .padding(.trailing, showBigGuide ? 0 : 16 )
        }
        .onTapGesture {
            showBigGuide.toggle()
            HapticManager.impact(style: .light)
        }
    }
}

extension CourseGuideView {
    private var coursePath: some View {
        PathGenerateManager
            .caculateLines(width: width, height: height, coordinates: coursePathCoordinates)
            .stroke(lineWidth: showBigGuide ? 15 : 7)
            .scaleEffect(0.8)
            .foregroundStyle(Color.customBlack.opacity(0.5))
            
    }
    
    private var userPath: some View {
        let canvasData = PathGenerateManager.calculateCanvaData(coordinates: coursePathCoordinates, width: width, height: height)
        
        return PathGenerateManager
            .caculateLines(width: width, height: height, coordinates: userLocations, canvasData: canvasData)
            .stroke(lineWidth: showBigGuide ? 15 : 7)
            .scaleEffect(0.8)
            .foregroundStyle(Color.customPrimary)
    }
}
