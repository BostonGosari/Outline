//
//  CourseGuidView.swift
//  Outline
//
//  Created by hyebin on 10/25/23.
//

import CoreLocation
import SwiftUI

struct CourseGuidView: View {
    @Binding var userLocations: [CLLocationCoordinate2D]
    @Binding var showBigGuid: Bool
    
    private let pathManager = PathGenerateManager.shared
    let coursePathCoordinates: [CLLocationCoordinate2D]
    let courseRotate: Double
    
    var width: Double {
        return showBigGuid ? 320 : 113
    }
    
    var height: Double {
        return showBigGuid ? 480 : 168
    }
    
    var body: some View {
        ZStack(alignment: showBigGuid ? .top : .topTrailing) {
            if showBigGuid {
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
                .padding(.top, showBigGuid ? 100 : 16)
                .padding(.trailing, showBigGuid ? 0 : 16 )
        }
        .onTapGesture {
            showBigGuid.toggle()
            // TODO: 햅틱 추가
        }
    }
}

extension CourseGuidView {
    private var coursePath: some View {
        pathManager
            .caculateLines(width: width, height: height, coordinates: coursePathCoordinates)
            .stroke(lineWidth: showBigGuid ? 15 : 7)
            .scaleEffect(0.8)
            .foregroundStyle(Color.blackColor.opacity(0.5))
            
    }
    
    private var userPath: some View {
        let canvasData = pathManager.calculateCanvaData(coordinates: coursePathCoordinates, width: width, height: height)
        
        return pathManager
            .caculateLines(width: width, height: height, coordinates: userLocations, canvasData: canvasData)
            .stroke(lineWidth: showBigGuid ? 15 : 7)
            .scaleEffect(0.8)
            .foregroundStyle(Color.primaryColor)
    }
}
