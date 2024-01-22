//
//  PathManager.swift
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

struct PathManager {
    static func createPath(width: Double, height: Double, coordinates: [CLLocationCoordinate2D], canvasData: CanvasData? = nil) -> some Shape {
        let data = canvasData ?? getCanvasData(coordinates: coordinates, width: width, height: height)
        var path = Path()
        
        if coordinates.isEmpty {
            return path
        }
        
        let initialPosition = getRelativePoint(coordinate: coordinates[0], canvasData: data)
        path.move(to: CGPoint(x: initialPosition.x, y: -initialPosition.y))
        
        for coordinate in coordinates {
            let position = getRelativePoint(coordinate: coordinate, canvasData: data)
            path.addLine(to: CGPoint(x: position.x, y: -position.y))
        }
        
        return path
    }
    
    static func getCanvasData(coordinates: [CLLocationCoordinate2D], width: Double, height: Double) -> CanvasData {
        // longitude 는 넓이(가로), latitude 는 높이(세로)와 관련
        let bound = coordinates.getBound()
        
        let longitudeRange = bound.maxLon - bound.minLon
        let latitudeRange = bound.maxLat - bound.minLat
        
        var scale: Double = 0
        
        // 넓이가 높이보다 클 경우 넓이의 scale을, 높이가 넓이보다 클 경우 높이의 scale 을 따릅니다.
        if longitudeRange >= latitudeRange {
            scale = width / longitudeRange
        } else {
            scale = height / latitudeRange
        }
        
        let fittedWidth = longitudeRange * scale
        let fittedHeight = latitudeRange * scale
        
        return CanvasData(
            width: fittedWidth,
            height: fittedHeight,
            scale: scale,
            initX: bound.minLon,
            initY: bound.maxLat
        )
    }
    
    static func getLineWidth(coordinates: [CLLocationCoordinate2D]) -> CGFloat {
        guard !coordinates.isEmpty else { return 1.0 }
        
        let bound = coordinates.getBound()
        
        let minCoordinate = CLLocation(latitude: bound.minLat, longitude: bound.minLon)
        let maxCoordinate = CLLocation(latitude: bound.maxLat, longitude: bound.maxLon)
        // 해당 맵의 대각선의 거리를 구합니다. 단위: meter
        let distanceInMeters = minCoordinate.distance(from: maxCoordinate)

        // 최대, 최소 라인 두께를 구합니다.
        let maxWidth: CGFloat = 5.0
        let minWidth: CGFloat = 1.0
        let maxDistanceThreshold: Double = 4000

        let normalizedDistance = min(max(distanceInMeters / maxDistanceThreshold, 0), 1)

        return minWidth + (maxWidth - minWidth) * normalizedDistance
    }
    
    static private func getRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasData) -> CGPoint {
        let tempX = (coordinate.longitude - canvasData.initX) * canvasData.scale
        let tempY = (coordinate.latitude - canvasData.initY) * canvasData.scale
        
        guard !tempX.isNaN, !tempX.isInfinite, !tempY.isNaN, !tempY.isInfinite else {
            return CGPoint.zero
        }
        
        return CGPoint(x: Int(tempX), y: Int(tempY))
    }
}
