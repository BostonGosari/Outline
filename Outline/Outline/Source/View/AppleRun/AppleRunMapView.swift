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
    
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @State private var subCoordinates: [CLLocationCoordinate2D] = []
    @State private var userLocations: [CLLocationCoordinate2D] = []

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map {
                MapPolyline(coordinates: coordinates)
                    .stroke(.white30, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                
                MapPolyline(coordinates: userLocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                
                Annotation("", coordinate: userLocations.last ?? CLLocationCoordinate2D(latitude: 36.0145573, longitude: 129.3256066)) {
                    ZStack {
                        Circle()
                            .frame(width: 18)
                            .foregroundStyle(.gray300)
                        Circle()
                            .frame(width: 12)
                            .foregroundStyle(.customPrimary)
                    }
                }

            }
            .mapStyle(.standard(pointsOfInterest: []))
            .mapControlVisibility(.hidden)
        }
        .tint(.customPrimary)
        .onAppear {
            getGPSArtCourseData()
            print(coordinates)
        }
        .onChange(of: appleRunManager.progress) { _, newValue in
            let count = coordinates.count
            let index = Int(newValue * Double(count))
            withAnimation {
                userLocations = Array(coordinates.prefix(index))
            }
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
