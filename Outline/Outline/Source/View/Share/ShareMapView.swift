//
//  ShareMapView.swift
//  Outline
//
//  Created by hyebin on 9/16/24.
//

import MapKit
import SwiftUI

struct ShareMapView: UIViewRepresentable {
    private let mapView = MKMapView()
    var userLocations: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsCompass = false
        
        let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
        mapView.addOverlay(polyline)
        
        let rect = polyline.boundingMapRect
        let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        mapView.setVisibleMapRect(rect, edgePadding: edgePadding, animated: false)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ShareMapView
        
        init(_ parent: ShareMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .customPrimary
                renderer.lineWidth = 5
                renderer.lineCap = .round
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func captureMapSnapshot(size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let snapshotOptions = MKMapSnapshotter.Options()
        let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
        
        var boundingMapRect = polyline.boundingMapRect
        
        let offsetRatio: CGFloat = 0.2
        let centerOffset = boundingMapRect.height * offsetRatio
        boundingMapRect = boundingMapRect.offsetBy(dx: 0, dy: -centerOffset)
        
        let padding: CGFloat = -800
        boundingMapRect = boundingMapRect.insetBy(dx: padding, dy: padding)
        
        let region = MKCoordinateRegion(boundingMapRect)
        snapshotOptions.region = region
        snapshotOptions.size = size
        let scale = UIScreen.main.scale
        snapshotOptions.scale = scale
        
        let snapshotter = MKMapSnapshotter(options: snapshotOptions)
        snapshotter.start { snapshot, _ in
            guard let snapshot = snapshot else { return }
            
            let image = snapshot.image
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(at: .zero)
            
            let context = UIGraphicsGetCurrentContext()
            
            // 베지어 곡선으로 폴리라인 그리기
            context?.setStrokeColor(UIColor.customPrimary.cgColor)
            context?.setLineWidth(5)
            context?.setLineCap(.round)
            
            let path = UIBezierPath()
            path.lineWidth = 5
            
            if userLocations.count > 1 {
                let firstLocation = userLocations[0]
                let firstPoint = snapshot.point(for: firstLocation)
                path.move(to: firstPoint)
                
                for i in 1..<userLocations.count {
                    let currentLocation = userLocations[i]
                    let currentPoint = snapshot.point(for: currentLocation)
                    
                    if i < userLocations.count - 1 {
                        let nextLocation = userLocations[i + 1]
                        let nextPoint = snapshot.point(for: nextLocation)
                        
                        let midPoint = CGPoint(x: (currentPoint.x + nextPoint.x) / 2, y: (currentPoint.y + nextPoint.y) / 2)
                        
                        path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
                    } else {
                        path.addLine(to: currentPoint)
                    }
                }
            }
            
            path.stroke()
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completion(finalImage)
        }
    }
}
