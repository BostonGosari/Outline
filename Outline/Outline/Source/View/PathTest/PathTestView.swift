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
              
            PathGenerateManager.caculateLines(width: 400, height: 400, coordinates: coordinates.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }))
                .fill(.clear)
                .stroke(.customBlack, style: .init(lineWidth: 10, lineCap: .round, lineJoin: .round) )
        }
        .background(Color.customPrimary)
        .frame(width: 400, height: 400)
        .onAppear {
            getGPSArtCourseData()
        }
    }
}

extension PathTestView {
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

#Preview {
    PathTestView()
}
