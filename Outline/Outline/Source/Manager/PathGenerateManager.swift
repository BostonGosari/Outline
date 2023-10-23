//
//  PathGenerateManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import SwiftUI

struct CanvasData {
    var width: Int
    var height: Int
    var scale: Double
    var zeroX: Double
    var zeroY: Double
}

struct CanvasDataForShare {
    var width: Int
    var height: Int
    var widthScale: Double
    var heightScale: Double
    var zeroX: Double
    var zeroY: Double
}

final class PathGenerateManager {
    static let shared = PathGenerateManager()
    private init() {}

    func caculateLines(width: Double, height: Double, coordinates: [CLLocationCoordinate2D]) -> some Shape {
        let canvasData = calculateCanvaData(coordinates: coordinates, width: width, height: height)
        var path = Path()
        
        let position = calculateRelativePoint(coordinate: coordinates[0], canvasData: canvasData)
        path.move(to: CGPoint(x: position[0], y: -position[1]))
        
        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position[0], y: -position[1]))
        }
        
        return path
    }
    private func calculateRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasData) -> [Int] {
        let posX = Int((coordinate.longitude - canvasData.zeroX) * canvasData.scale * 1000000)
        let posY = Int((coordinate.latitude - canvasData.zeroY) * canvasData.scale * 1000000)
        return [posX, posY]
    }
    private func calculateCanvaData(coordinates: [CLLocationCoordinate2D], width: Double, height: Double) -> CanvasData {
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLon: Double = 180
        var maxLon: Double = -180
        for coordinate in coordinates {
            if coordinate.latitude < minLat {
                minLat = coordinate.latitude
            }
            if coordinate.latitude > maxLat {
                maxLat = coordinate.latitude
            }
            if coordinate.longitude < minLon {
                minLon = coordinate.longitude
            }
            if coordinate.longitude > maxLon {
                maxLon = coordinate.longitude
            }
        }
        let calculatedHeight = (maxLat - minLat) * 1000000
        let calculatedWidth = (maxLon - minLon) * 1000000
        
        var relativeScale: Double = 0
        
        if calculatedWidth > calculatedHeight {
            relativeScale = width / calculatedWidth
        } else {
            relativeScale = height / calculatedHeight
        }
        let fittedWidth = calculatedWidth * relativeScale
        let fittedHeight = calculatedHeight * relativeScale
        
        return CanvasData(
            width: Int(fittedWidth),
            height: Int(fittedHeight),
            scale: relativeScale,
            zeroX: minLon,
            zeroY: maxLat
            )
    }
}
