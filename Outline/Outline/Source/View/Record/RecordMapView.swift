//
//  RecordMapView.swift
//  Outline
//
//  Created by hyebin on 1/24/24.
//

import MapKit
import SwiftUI

struct RecordMapView: UIViewRepresentable {
    private let mapView = MKMapView()
    let userLocations: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false

        loadMapDataAsync()
 
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    private func loadMapDataAsync() {
        DispatchQueue.main.async {
            let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
            let edgePadding = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
            mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePadding, animated: false)
            mapView.addOverlay(polyline)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RecordMapView
        
        init(_ parent: RecordMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .customPrimary
            renderer.lineWidth = 4
            return renderer
        }
    }
}

#Preview {
    RecordMapView(userLocations: [])
}
