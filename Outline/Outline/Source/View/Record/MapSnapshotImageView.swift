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

// 마지막 가까운 거리 연결해주기, 짧은경로 뜨지 않는 문제
// 랜더링 문제 속도가 조금 늦음, 이미지 자체를 다 저장하고싶은데...(캐싱 최적화)
struct MapSnapshotImageView: UIViewRepresentable {
    let coordinates: [CLLocationCoordinate2D]
    let width: CGFloat
    let height: CGFloat
    let alpha: CGFloat
    let lineWidth: CGFloat
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        updateSnapshot(for: imageView)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {

    }
    
    private func updateSnapshot(for imageView: UIImageView) {
        let cacheKey = "\(coordinates)-\(width)-\(height)-\(alpha)-\(lineWidth)"
        
        if let cachedImage = MapSnapshotCache.shared.image(forKey: cacheKey) {
            imageView.image = cachedImage
            return
        }
        
        createMapSnapshot { image in
            if let image = image {
                MapSnapshotCache.shared.setImage(image, forKey: cacheKey)
            }
            imageView.image = image
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
        let regionMultiplier: Double = coordinates.isEmpty ? 2.0 : 1.4
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
        
        // 기존 smooth 메서드
        guard coordinates.count > 1 else { return }
        
        let path = UIBezierPath()
        
        let firstPoint = snapshot.point(for: coordinates[0])
        path.move(to: firstPoint)
        
        for i in 1..<coordinates.count {
            let point = snapshot.point(for: coordinates[i])
            path.addLine(to: point)
        }
        
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        
        let uiColor = UIColor(Color.customPrimary)
        context?.setStrokeColor(uiColor.cgColor)
        
        context?.addPath(path.cgPath)
        context?.setLineWidth(lineWidth)
        context?.strokePath()
    }
    
    private func filterCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        var filtered: [CLLocationCoordinate2D] = []
        
        for coordinate in coordinates {
            if let last = filtered.last {
                let current = CLLocation(from: last)
                let new = CLLocation(from: coordinate)
                if current.distance(from: new) >= 10 {
                    filtered.append(coordinate)
                }
            } else {
                filtered.append(coordinate)
            }
        }
        
        return filtered.count > 2 ? filtered : coordinates
    }
    
    private func smoothLocations(_ locations: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        guard locations.count > 1 else { return locations }
        
        var smoothed: [CLLocationCoordinate2D] = []
        for i in 0..<locations.count {
            let start = max(0, i - 2)
            let end = min(locations.count - 1, i + 2)
            let subset = Array(locations[start...end])
            
            let avgLatitude = subset.map { $0.latitude }.reduce(0, +) / Double(subset.count)
            let avgLongitude = subset.map { $0.longitude }.reduce(0, +) / Double(subset.count)
            
            smoothed.append(CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude))
        }
        
        return smoothed
    }
}

#Preview {
    MapSnapshotTestView(fileName: "")
}
