//
//  Map.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit

struct RecomendedCourseMap: UIViewRepresentable {
    
    @Binding var userLocation: CLLocationCoordinate2D?
    
    var camera: MKMapCamera
    var coordinates: [CLLocationCoordinate2D] = []
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        mapView.camera = camera
        mapView.isUserInteractionEnabled = false
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RecomendedCourseMap
        
        init(_ parent: RecomendedCourseMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let coursePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: coursePolyline)
                renderer.strokeColor = UIColor.orange
                renderer.lineWidth = 3
                renderer.alpha = 0.5
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            parent.userLocation = userLocation.coordinate
        }
    }
}
