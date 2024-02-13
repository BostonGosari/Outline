//
//  MapInfoView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/20/23.
//

import SwiftUI
import MapKit

struct MapInfoView: UIViewRepresentable {
    
    var coordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.isUserInteractionEnabled = true
        mapView.showsUserLocation = true
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        if !coordinates.isEmpty {
            let region = MKCoordinateRegion(polyline.boundingMapRect)
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapInfoView
        
        init(_ parent: MapInfoView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = UIColor(Color.customPrimary)
                renderer.lineWidth = 4
                renderer.lineCap = .round
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
