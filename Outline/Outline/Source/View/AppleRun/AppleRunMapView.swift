//
//  AppleRunMapView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import MapKit
import SwiftUI

struct AppleRunMapView: View {
    @StateObject private var appleRunManager = AppleRunManager.shared
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Namespace private var mapScope
    
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @State private var subCoordinates: [CLLocationCoordinate2D] = []
    @State private var userLocations: [CLLocationCoordinate2D] = []

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
                MapPolyline(coordinates: coordinates)
                    .stroke(.white30, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))

                MapPolyline(coordinates: subCoordinates)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                
                MapPolyline(coordinates: userLocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))

            }
            .mapStyle(.standard(pointsOfInterest: []))
            .mapControlVisibility(.hidden)
        }
        .mapScope(mapScope)
        .tint(.customPrimary)
        .onAppear {
            getGPSArtCourseData()
        }
    }
    
    private func getGPSArtCourseData() {
        let parsedCoordinates = parseCooridinates(fileName: "AppleRun")
        let parsedSubCoordinates = parseCooridinates(fileName: "AppleRunTail")
        self.coordinates = parsedCoordinates
        self.subCoordinates = parsedSubCoordinates
    }
    
    private func parseCooridinates(fileName: String) -> [CLLocationCoordinate2D] {
        if let kmlFilePath = Bundle.main.path(forResource: fileName, ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath).map { clLocation2D in
                CLLocationCoordinate2D(latitude: clLocation2D.latitude, longitude: clLocation2D.longitude)
            }
        }
        return []
    }
}

#Preview {
    AppleRunMapView()
}
