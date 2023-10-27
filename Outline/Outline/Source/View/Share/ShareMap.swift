//
//  ShareMap.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import MapKit
import SwiftUI

struct ShareMap: UIViewRepresentable {
    
    @Binding var mapView: MKMapView
    @Binding var mapViewRegion: MKCoordinateRegion
    let userLocations: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        
        let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
        mapView.addOverlay(polyline)
        
        if !userLocations.isEmpty {
            let region = MKCoordinateRegion(polyline.boundingMapRect)
            mapViewRegion = region
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ShareMap
        
        init(_ parent: ShareMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .white
                renderer.lineWidth = 15
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
