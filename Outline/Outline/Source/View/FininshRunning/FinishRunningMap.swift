//
//  FinishRunningMap.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import MapKit
import SwiftUI

struct FinishRunningMap: UIViewRepresentable {
    let userLocations: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        
        let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: FinishRunningMap
        
        init(_ parent: FinishRunningMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKGradientPolylineRenderer(polyline: polyline)
                renderer.setColors([
                    UIColor(red: 30, green: 30, blue: 32, alpha: 1),
                    UIColor(red: 100, green: 120, blue: 255, alpha: 1),
                    UIColor(red: 219, green: 251, blue: 108, alpha: 1)
                ], locations: [])
                renderer.lineWidth = 15
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
