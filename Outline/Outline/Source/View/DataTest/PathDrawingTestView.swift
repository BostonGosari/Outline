//
//  PathDrawingTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import SwiftUI

let gradient = LinearGradient(colors: [Color.gradient1, Color.gradient3], startPoint: .top, endPoint: .bottom)

struct PathDrawingTestView: View {
    private let pathManager = PathGenerateManager.shared
    
    let testCoordinates: [CLLocationCoordinate2D] = {
        if let kmlFilePath = Bundle.main.path(forResource: "duckRun", ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath)
        }
        return []
    }()
    
    var body: some View {
        ZStack {
            Color.fourth
            pathManager
                .caculateLines(width: 300, height: 300, coordinates: testCoordinates)
                .stroke(Color.gradient3, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: 90))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PathDrawingTestView()
}
