//
//  CourseGuideView.swift
//  Outline
//
//  Created by hyebin on 10/25/23.
//

import CoreLocation
import SwiftUI

struct CourseGuideView: View {
    @Binding var userLocations: [CLLocationCoordinate2D]
    @Binding var showBigGuide: Bool
    
    private let pathManager = PathGenerateManager.shared
    let coursePathCoordinates: [CLLocationCoordinate2D]
    let courseRotate: Double
    
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
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.7))
                .stroke(.white)
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
            HapticManager.impact(style: .soft)
        }
    }
}

extension CourseGuideView {
    private var coursePath: some View {
        pathManager
            .caculateLines(width: width, height: height, coordinates: coursePathCoordinates)
            .stroke(lineWidth: showBigGuide ? 15 : 7)
            .scaleEffect(0.8)
            .foregroundStyle(Color.customBlack.opacity(0.5))
            
    }
    
    private var userPath: some View {
        let canvasData = pathManager.calculateCanvaData(coordinates: coursePathCoordinates, width: width, height: height)
        
        return pathManager
            .caculateLines(width: width, height: height, coordinates: userLocations, canvasData: canvasData)
            .stroke(lineWidth: showBigGuide ? 15 : 7)
            .scaleEffect(0.8)
            .foregroundStyle(Color.customPrimary)
    }
}
