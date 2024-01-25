//
//  CardDetailInformationMapView.swift
//  Outline
//
//  Created by hyebin on 1/22/24.
//

import MapKit
import SwiftUI

struct CardDetailInformationMapView: UIViewRepresentable {
    private let mapView = MKMapView()
    let coursePaths: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        
        let polyline = MKPolyline(coordinates: coursePaths, count: coursePaths.count)
        let edgePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePadding, animated: false)
        mapView.addOverlay(polyline)
    
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CardDetailInformationMapView
        
        init(_ parent: CardDetailInformationMapView) {
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
    CardDetailInformationMapView(coursePaths: [])
}
