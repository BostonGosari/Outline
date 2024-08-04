//
//  MapSnapshotTestView.swift
//  Outline
//
//  Created by hyunjun on 8/2/24.
//

import SwiftUI

#if DEBUG
struct MapSnapshotTestView: View {
    private let parseManager = KMLParserManager()
    let fileName: String
    
    var body: some View {
        let coordinates = parseCooridinates(fileName: fileName).toCLLocationCoordinates()
        
        MapSnapshotImageView(coordinates: coordinates, width: 300, height: 500, alpha: 0.6, lineWidth: 4.0)
            .scaledToFit()
        
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
#endif

#Preview {
    MapSnapshotTestView(fileName: "건대 오리런")
}
