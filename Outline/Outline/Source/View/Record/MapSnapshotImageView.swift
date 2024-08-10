//
//  MapSnapshotImageView.swift
//  Outline
//
//  Created by hyunjun on 8/3/24.
//

import UIKit
import SwiftUI
import MapKit

class MapSnapshotCache {
    static let shared = MapSnapshotCache()
    private let cache = NSCache<NSString, UIImage>()
    
    // 최대 100개 항목 총 10MB 캐싱 메모리 할당
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

struct MapSnapshotImageView: UIViewRepresentable {
    let coordinates: [CLLocationCoordinate2D]
    let width: CGFloat
    let height: CGFloat
    let alpha: CGFloat // 배경 어둡기
    let lineWidth: CGFloat // 라인 두께
    let heading: CLLocationDirection? = nil // 경로 heading
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        updateSnapshot(for: imageView)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) { }
    
    private func updateSnapshot(for imageView: UIImageView) {
        let cacheKey = "\(coordinates)-\(width)-\(height)-\(alpha)-\(lineWidth)"
        
        if let cachedImage = MapSnapshotCache.shared.image(forKey: cacheKey) {
            imageView.image = cachedImage
            return
        }
        
        DispatchQueue.main.async {
            createMapSnapshot { image in
                if let image = image {
                    MapSnapshotCache.shared.setImage(image, forKey: cacheKey)
                }
                imageView.image = image
            }
        }
    }
    
    private func createMapSnapshot(completion: @escaping (UIImage?) -> Void) {
        let defaultCoordinates = [
            CLLocationCoordinate2D(latitude: 37.4563, longitude: 126.7052),  // 인천
            CLLocationCoordinate2D(latitude: 35.1796, longitude: 129.0756)   // 부산
        ]
        
        let actualCoordinates = coordinates.isEmpty ? defaultCoordinates : coordinates
        
        // Polyline을 생성하고 해당 경로의 경계를 계산
        let polyline = MKPolyline(coordinates: actualCoordinates, count: actualCoordinates.count)
        var region = MKCoordinateRegion(polyline.boundingMapRect)
        
        // 경로가 주어지지 않았을 때, 전국 지도를 표시
        let regionMultiplier: Double = coordinates.isEmpty ? 2.0 : 1.6
        region.span.latitudeDelta *= regionMultiplier
        region.span.longitudeDelta *= regionMultiplier
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: width, height: height)
        options.scale = 1.0
        
        // 맵 설정
        let configuration = MKStandardMapConfiguration(emphasisStyle: .muted)
        configuration.pointOfInterestFilter = .excludingAll
        options.preferredConfiguration = configuration
    
        if let heading = heading {
            options.camera.heading = heading
        }
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, _ in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            let image = snapshot.image
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(at: .zero)
            
            // 맵을 어둡게 하기 위한 오버레이 추가 (Multiply 블렌드 모드 사용)
            let overlayRect = CGRect(origin: .zero, size: image.size)
            UIColor(white: 0, alpha: alpha).setFill()
            UIRectFillUsingBlendMode(overlayRect, .multiply)
            
            let context = UIGraphicsGetCurrentContext()
            
            if !coordinates.isEmpty {
                drawPolyline(on: snapshot, in: context)
            }
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completion(resultImage)
        }
    }
    
    private func drawPolyline(on snapshot: MKMapSnapshotter.Snapshot, in context: CGContext?) {
        guard coordinates.count > 1 else { return }
        
        let path = UIBezierPath()
        
        var coordinates = coordinates
        coordinates = gaussianSmoothing(coordinates: coordinates, size: 3, sigma: 1)
        coordinates = closePathIfEndpointsMatch(coordinates: coordinates)
        
        let firstPoint = snapshot.point(for: coordinates[0])
        path.move(to: firstPoint)
        
        for i in 1..<coordinates.count {
            let point = snapshot.point(for: coordinates[i])
            path.addLine(to: point)
        }
                        
        let uiColor = UIColor(Color.customPrimary)
        context?.setStrokeColor(uiColor.cgColor)
        
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.addPath(path.cgPath)
        context?.setLineWidth(lineWidth)
        context?.strokePath()
    }
    
    func closePathIfEndpointsMatch(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        guard coordinates.count >= 10 else { return coordinates } // 너무 짧은 경로일 경우 반환
        guard let first = coordinates.first, let last = coordinates.last else { return coordinates }
        let firstLocation = first.toCLLocation()
        let lastLocation = last.toCLLocation()
        var coordinates = coordinates
        
        if firstLocation.distance(from: lastLocation) <= 10 { coordinates.append(first) }
        return coordinates
    }

    func gaussianSmoothing(coordinates: [CLLocationCoordinate2D], size: Int, sigma: Double) -> [CLLocationCoordinate2D] {
        // size가 0이거나 coordinates 배열의 크기보다 클 경우 원본 배열 반환
        guard size > 0, coordinates.count >= size else { return coordinates }
        let kernel = gaussianKernel(size: size, sigma: sigma)
        // 러닝 특성상 첫번째 값은 무조건 필요하기 때문에 첫번째 값 추가
        var smoothedCoordinates: [CLLocationCoordinate2D] = [coordinates[0]]
        
        for i in 0..<(coordinates.count - size + 1) {
            let window = coordinates[i..<i+size]
            let sumLatitude = zip(window, kernel).map { $0.latitude * $1 }.reduce(0, +)
            let sumLongitude = zip(window, kernel).map { $0.longitude * $1 }.reduce(0, +)
            smoothedCoordinates.append(CLLocationCoordinate2D(latitude: sumLatitude, longitude: sumLongitude))
        }
        
        return smoothedCoordinates
    }
    
    func gaussianKernel(size: Int, sigma: Double) -> [Double] {
        let mean = Double(size) / 2
        let kernel = (0..<size).map { i in
            exp(-0.5 * pow((Double(i) - mean) / sigma, 2))
        }
        let sum = kernel.reduce(0, +)
        return kernel.map { $0 / sum }
    }
}

#Preview {
    MapSnapshotTestView(fileName: "압구정 댕댕런 테스트 촘촘", lineWidth: 4)
}
