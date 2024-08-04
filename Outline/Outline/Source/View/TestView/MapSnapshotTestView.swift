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
    let lineWidth: CGFloat
    
    var body: some View {
        let coordinates = parseCooridinates(fileName: fileName).toCLLocationCoordinates()
        
        MapSnapshotImageView(coordinates: coordinates, width: 300, height: 500, alpha: 0.6, lineWidth: lineWidth)
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
    MapSnapshotTestView(fileName: "건대 오리런", lineWidth: 4.0)
}

#Preview {
    BigCard(
        cardType: .excellent,
        runName: "댕댕런",
        date: "2024.8.4",
        editMode: false,
        time: "20:00.10",
        distance: "1000KM",
        pace: "9'99''",
        kcal: "100",
        bpm: "100",
        score: 100,
        editAction: {
            // edit Action here
        },
        content: {
            MapSnapshotTestView(fileName: "압구정 댕댕런", lineWidth: 4.0)
        }
    )
}
