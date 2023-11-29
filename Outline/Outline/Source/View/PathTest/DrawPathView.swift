//
//  DrawPathView.swift
//  Outline
//
//  Created by hyunjun on 11/29/23.
//

import MapKit
import SwiftUI

struct DrawPathView: View {
    @State private var coordinates: [Coordinate] = []
    private let parseManager = KMLParserManager()    
    let heading: Double = 0
    
    var body: some View {
        PathView(coordinates: coordinates, heading: heading, frame: 200)
            .onAppear {
                getGPSArtCourseData()
            }
    }
}

extension DrawPathView {
    private func getGPSArtCourseData() {
        let parsedCoordinates = parseCooridinates(fileName: "seoulOctopusRun")
        self.coordinates = parsedCoordinates
    }
    
    private func parseCooridinates(fileName: String) -> [Coordinate] {
        if let kmlFilePath = Bundle.main.path(forResource: fileName, ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath).map { clLocation2D in
                Coordinate(longitude: clLocation2D.longitude, latitude: clLocation2D.latitude)
            }
        }
        return []
    }
}

struct PathView: View {
    var coordinates: [Coordinate]
    var heading: Double
    var frame: CGFloat
    var colors: [Color] = [.customSecondary, .customPrimary, .customPrimary]
    var lineWidth: CGFloat = 6
        
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let minX = coordinates.map { $0.longitude }.min() ?? 0.0
                let minY = coordinates.map { $0.latitude }.min() ?? 0.0
                let maxX = coordinates.map { $0.longitude }.max() ?? 1.0
                let maxY = coordinates.map { $0.latitude }.max() ?? 1.0
                                
                for coordinate in coordinates {
                    let x = CGFloat(coordinate.longitude - minX) * geometry.size.width / (maxX - minX)
                    let y = CGFloat(coordinate.latitude - minY) * geometry.size.height / (maxY - minY)
                    let point = CGPoint(x: x, y: y)
                    
                    if path.isEmpty {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        }
        .rotationEffect(.degrees(heading), anchor: .center)
        .frame(width: frame, height: frame * 0.8)
        .scaledToFill()
    }
}

#Preview {
    DrawPathView()
}
