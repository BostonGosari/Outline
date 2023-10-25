//
//  CourseGuidView.swift
//  Outline
//
//  Created by hyebin on 10/25/23.
//

import CoreLocation
import SwiftUI

struct CourseGuidView: View {
    // homeTabViewModel 불러와서 path 정보 표시
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
    
    let testCoordinates: [CLLocationCoordinate2D] = {
        if let kmlFilePath = Bundle.main.path(forResource: "pohangDuckRun", ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath)
        }
        return []
    }()
    
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
//                            userPath
                        }
                        .scaleEffect(0.8)
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
            .scaledToFit()
            .rotationEffect(Angle(degrees: courseRotate))
            .foregroundStyle(Color.blackColor.opacity(0.5))
            .frame(width: width, height: height, alignment: .center)
    }
    
    private var userPath: some View {
        pathManager
            .caculateLines(width: width, height: height, coordinates: testCoordinates)
            .stroke(lineWidth: showBigGuid ? 15 : 7)
            .scaledToFit()
            .rotationEffect(Angle(degrees: courseRotate))
            .foregroundStyle(Color.primaryColor)
            .frame(width: width, height: height, alignment: .center)
    }
}
