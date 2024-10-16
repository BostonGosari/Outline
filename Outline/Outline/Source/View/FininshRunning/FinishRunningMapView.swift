//
//  FinishRunningMapView.swift
//  Outline
//
//  Created by hyebin on 1/23/24.
//

import MapKit
import SwiftUI

struct FinishRunningMapView: UIViewRepresentable {
    private let mapView = MKMapView()
    let userLocations: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        
        let configuration = MKStandardMapConfiguration()
        configuration.emphasisStyle = .muted
        configuration.pointOfInterestFilter = .init(including: [.airport, .university, .hospital, .pharmacy, .police, .library, .park])
        mapView.preferredConfiguration = configuration

        let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
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
        var parent: FinishRunningMapView
        
        init(_ parent: FinishRunningMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKGradientPolylineRenderer(overlay: overlay)
            renderer.setColors([.customGradient2, .customGradient3, .customGradient3, .customGradient3, .customGradient2], locations: [])
            renderer.lineCap = .round
            renderer.lineWidth = 4
            return renderer
        }
    }
}

#Preview {
    FinishRunningMapView(userLocations: [])
}
