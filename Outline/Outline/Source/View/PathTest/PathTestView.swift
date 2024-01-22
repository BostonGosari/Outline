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
    @State private var coordinates: [Coordinate] = []
    
    private let parseManager = KMLParserManager()
    private let width = 250.0
    private let height = 200.0
    private let fileName = "fish"
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                PathGenerateManager.caculateLines(width: width, height: height, coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }))
                    .stroke(.customGreen, style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round) )
                    .overlay {
                        VStack {
                            Text("\(PathGenerateManager.calculateCanvasData(coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }), width: width, height: height).width)")
                            Text("\(PathGenerateManager.calculateCanvasData(coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }), width: width, height: height).height)")
                            Text("\(geo.size.width)")
                            Text("\(geo.size.height)")
                        }
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

#Preview {
    PathTestView()
}
