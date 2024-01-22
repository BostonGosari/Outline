//
//  CoordinatePathManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct CanvasData {
    var width: Double
    var height: Double
    var scale: Double
    var initX: Double
    var initY: Double
}

struct CoordinatePathManager {
    static func createPath(width: Double, height: Double, coordinates: [CLLocationCoordinate2D], canvasData: CanvasData? = nil) -> some Shape {
        let data = canvasData ?? calculateCanvasData(coordinates: coordinates, width: width, height: height)
        var path = Path()
        
        if coordinates.isEmpty {
            return path
        }
        
        let initialPosition = computeRelativePoint(coordinate: coordinates[0], canvasData: data)
        path.move(to: CGPoint(x: initialPosition.x, y: -initialPosition.y))
        
        for coordinate in coordinates {
            let position = computeRelativePoint(coordinate: coordinate, canvasData: data)
            path.addLine(to: CGPoint(x: position.x, y: -position.y))
        }
        
        return path
    }
    
    static func calculateCanvasData(coordinates: [CLLocationCoordinate2D], width: Double, height: Double) -> CanvasData {
        // latitude 는 높이, longitude 는 넓이
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        let minLat = latitudes.min() ?? 90
        let maxLat = latitudes.max() ?? -90
        let minLon = longitudes.min() ?? 180
        let maxLon = longitudes.max() ?? -180
        
        let latitudeRange = maxLat - minLat
        let longitudeRange = maxLon - minLon
        
        var scale: Double = 0
        
        // 높이가 넓이보다 클 경우 높이의 scale을, 넓이가 높이보다 클 경우 넓이의 scale 을 따릅니다.
        if latitudeRange >= longitudeRange {
            scale = height / latitudeRange
        } else {
            scale = width / longitudeRange
        }
        
        let fittedHeight = latitudeRange * scale
        let fittedWidth = longitudeRange * scale
        
        return CanvasData(
            width: fittedWidth,
            height: fittedHeight,
            scale: scale,
            initX: minLon,
            initY: maxLat
        )
    }
    
    static private func computeRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasData) -> CGPoint {
        let tempX = (coordinate.longitude - canvasData.initX) * canvasData.scale
        let tempY = (coordinate.latitude - canvasData.initY) * canvasData.scale
        
        guard !tempX.isNaN, !tempX.isInfinite, !tempY.isNaN, !tempY.isInfinite else {
            return CGPoint.zero
        }
        
        return CGPoint(x: Int(tempX), y: Int(tempY))
    }
}
