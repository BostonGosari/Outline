//
//  PathTestView.swift
//  Outline
//
//  Created by Seungui Moon on 11/12/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct PathTestView: View {
    @State private var coordinates: [CLLocationCoordinate2D] = []
    
    private let parseManager = KMLParserManager()
    private var width: Double = 300
    private var height: Double = 300
    private let fileName = "dangdang"
    
    var body: some View {
        ZStack {
            let canvasData = PathManager.getCanvasData(coordinates: coordinates, width: width, height: height)
            
            PathManager.createPath(width: width, height: height, coordinates: coordinates)
            .stroke(.green, style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round) )
            .frame(width: canvasData.width, height: canvasData.height)
            .background {
                Color.white.opacity(0.2)
            }
            .overlay {
                VStack {
                    Text("\(canvasData.width)")
                    Text("\(canvasData.height)")
                }
            }
        }
        .onAppear {
            getGPSArtCourseData()
        }
    }
}

extension PathTestView {
    private func getGPSArtCourseData() {
        let parsedCoordinates = parseCooridinates(fileName: fileName)
        self.coordinates = parsedCoordinates.toCLLocationCoordinates()
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

#Preview {
    PathTestView()
}
