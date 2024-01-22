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
    private let width = 200.0
    private let height = 200.0
    private let fileName = "fish"
    
    var body: some View {
        ZStack {
                PathManager.createPath(width: width, height: height, coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }))
                    .stroke(.green, style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round) )
                    .frame(width: PathManager.getCanvasData(coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }), width: width, height: height).width, height: PathManager.getCanvasData(coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }), width: width, height: height).height)
                    .overlay {
                        VStack {
                            Text("\(PathManager.getCanvasData(coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }), width: width, height: height).width)")
                            Text("\(PathManager.getCanvasData(coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }), width: width, height: height).height)")
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
