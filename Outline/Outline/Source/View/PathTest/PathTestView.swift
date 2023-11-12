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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white30)
                .frame(width: 100, height: 300)
            
            PathGenerateManager.caculateLines(width: 100, height: 300, coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }))
//            PathGenerateManager.caculateLinesInRect(
//                width: 300,
//                height: 100,
//                coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }),
//                region: PathGenerateManager.calculateDeltaAndCenter(coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })))
        }
        .frame(width: 100, height: 300)
        .onAppear {
            getGPSArtCourseData()
        }
    }
}

extension PathTestView {
    private func getGPSArtCourseData() {
        let parsedCoordinates = parseCooridinates(fileName: "pohangDangDangRun")
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
