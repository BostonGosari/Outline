//
//  PathGenerateManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import MapKit
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
    static func caculateLines(width: Double, height: Double, coordinates: [CLLocationCoordinate2D]) -> some Shape {
        let canvasData = calculateCanvaData(coordinates: coordinates, width: width, height: height)
        var path = Path()
        if coordinates.isEmpty {
            return path
        }
        
        let position = calculateRelativePoint(coordinate: coordinates[0], canvasData: canvasData)
        path.move(to: CGPoint(x: position[0], y: -position[1]))
        
        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position[0], y: -position[1]))
        }
        
        return path
    }
    static func caculateLines(width: Double, height: Double, coordinates: [CLLocationCoordinate2D], canvasData: CanvasData) -> some Shape {
        var path = Path()
        
        if coordinates.isEmpty {
            return path
        }
        
        let position = calculateRelativePoint(coordinate: coordinates[0], canvasData: canvasData)
        path.move(to: CGPoint(x: position[0], y: -position[1]))
        
        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position[0], y: -position[1]))
        }
        
        return path
    }
    
    static private func calculateRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasData) -> [Int] {
        var posX: Int = 0
        var posY: Int = 0
        let tempX = (coordinate.longitude - canvasData.zeroX) * canvasData.scale * 1000000
        let tempY = (coordinate.latitude - canvasData.zeroY) * canvasData.scale * 1000000
        if !(tempX.isNaN || tempX.isInfinite || tempY.isNaN || tempY.isInfinite) {
            posX = Int(tempX)
            posY = Int(tempY)
        } else {
            posX = 0
            posY = 0
        }
            
        return [posX, posY]
    }
    
    static func calculateCanvaData(coordinates: [CLLocationCoordinate2D], width: Double, height: Double) -> CanvasData {
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
            width: Int(fittedWidth > 0 ? fittedWidth : 200),
            height: Int(fittedHeight > 0 ? fittedHeight : 200),
            scale: relativeScale > 0 ? relativeScale : 2,
            zeroX: minLon,
            zeroY: maxLat
            )
    }
    
    // Path가 외부로 나오지 않게 방지하는 로직이 추가된 map의 coordinates에 따른 view의 상대 사이즈를 구하는 함수
    static func calculateCanvaDataForInBox(coordinates: [CLLocationCoordinate2D], width: Double, height: Double) -> CanvasData {
        let sizeStandard: Double = width < height ? width : height
        
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
            relativeScale = sizeStandard / calculatedWidth
        } else {
            relativeScale = sizeStandard / calculatedHeight
        }
        let fittedWidth = sizeStandard * relativeScale
        let fittedHeight = sizeStandard * relativeScale
        
        return CanvasData(
            width: Int(fittedWidth > 0 ? fittedWidth : 200),
            height: Int(fittedHeight > 0 ? fittedHeight : 200),
            scale: relativeScale > 0 ? relativeScale : 2,
            zeroX: minLon,
            zeroY: maxLat
            )
    }
}

extension PathGenerateManager {
    static func caculateLinesInRect(
        width: Double,
        height: Double,
        coordinates: [CLLocationCoordinate2D],
        region: MKCoordinateRegion
    ) -> some Shape {
        let canvasData = calculateCanvaDataInRect(width: width, height: height, region: region)
        var path = Path()
        
        if coordinates.isEmpty {
            return path
        }
        
        let startPosition = calculateRelativePoint(coordinate: coordinates[0], canvasData: canvasData)
        path.move(to: CGPoint(x: startPosition[0], y: -startPosition[1]))

        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position[0], y: -position[1]))
        }
        
        return path
    }
    
    static private func calculateCanvaDataInRect(width: Double, height: Double, region: MKCoordinateRegion) -> CanvasDataForShare {
        let minLon = region.center.longitude - region.span.longitudeDelta / 2
        let maxLat = region.center.latitude + region.span.latitudeDelta / 2
        
        let calculatedHeight = region.span.latitudeDelta * 1000000
        let calculatedWidth = region.span.longitudeDelta * 1000000
        
        let relativeWidthScale: Double = width / calculatedWidth
        let relativeHeightScale: Double = height / calculatedHeight
        
        let fittedWidth = calculatedWidth * relativeWidthScale
        let fittedHeight = calculatedHeight * relativeHeightScale
        return CanvasDataForShare(
            width: Int(fittedWidth),
            height: Int(fittedHeight),
            widthScale: relativeWidthScale,
            heightScale: relativeHeightScale,
            zeroX: minLon,
            zeroY: maxLat
            )
    }
    
    static func calculateDeltaAndCenter(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
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
        let latitudeDelta = maxLat - minLat
        let longitudeDelta = maxLon - minLon
        let centerLatitude = (maxLat + minLat) / 2
        let centerLongitude = (maxLon + minLon) / 2
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
    }
    
    static private func calculateRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasDataForShare) -> [Int] {
        let posX = Int((coordinate.longitude - canvasData.zeroX) * canvasData.widthScale * 1000000)
        let posY = Int((coordinate.latitude - canvasData.zeroY) * canvasData.heightScale * 1000000)
        return [posX, posY]
    }
}
