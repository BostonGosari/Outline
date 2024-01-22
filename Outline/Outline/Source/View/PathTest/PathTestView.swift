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
    func calculateCanvasData(coordinates: [CLLocationCoordinate2D]) -> CanvasData {
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }

        let minLat = latitudes.min() ?? 90
        let maxLat = latitudes.max() ?? -90
        let minLon = longitudes.min() ?? 180
        let maxLon = longitudes.max() ?? -180

        let latitudeRange = maxLat - minLat
        let longitudeRange = maxLon - minLon

        // 좌표들 사이의 최대 범위를 기준으로 스케일을 설정
        let scale = 1 / max(latitudeRange, longitudeRange)

        return CanvasData(
            width: longitudeRange * scale,
            height: latitudeRange * scale,
            scale: scale,
            initX: minLon,
            initY: maxLat
        )
    }
    
    func calculateLines(coordinates: [CLLocationCoordinate2D]) -> some Shape {
        let canvasData = calculateCanvasData(coordinates: coordinates)
        var path = Path()
        
        guard let firstCoordinate = coordinates.first else {
            return path
        }
        
        let initialPosition = calculateRelativePoint(coordinate: firstCoordinate, canvasData: canvasData)
        path.move(to: CGPoint(x: initialPosition.x, y: initialPosition.y))
        
        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position.x, y: position.y))
        }
        
        return path
    }
    
    func calculateRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasData) -> CGPoint {
        let tempX = (coordinate.longitude - canvasData.initX) * canvasData.scale
        let tempY = (coordinate.latitude - canvasData.initY) * canvasData.scale
        
        guard !tempX.isNaN, !tempX.isInfinite, !tempY.isNaN, !tempY.isInfinite else {
            return CGPoint.zero
        }
        
        return CGPoint(x: Int(tempX), y: Int(tempY))
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
