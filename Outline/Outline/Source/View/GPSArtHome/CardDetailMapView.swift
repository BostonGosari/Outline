//
//  CardDetailMapView.swift
//  Outline
//
//  Created by hyebin on 1/22/24.
//

import MapKit
import SwiftUI

struct CardDetailMapView: UIViewRepresentable {
    private let mapView = MKMapView()
    let coursePaths: [CLLocationCoordinate2D]
    let places: [Place]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        
        let polyline = MKPolyline(coordinates: coursePaths, count: coursePaths.count)
        let edgePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePadding, animated: false)
        mapView.addOverlay(polyline)
        
        for place in places {
            let marker = Marker(
                place.title, 
                image: place.id == 0  ? "flag.fill" : "mappin",
                coordinate: place.location
            )
                .tag(place)
                .tint(place.id == 0 ? .customRed : .customPrimary)
        }
    
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CardDetailMapView
        
        init(_ parent: CardDetailMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .customPrimary
            renderer.lineWidth = 8
            return renderer
        }
    }
}

#Preview {
    CardDetailMapView(coursePaths: [], places: [])
}
