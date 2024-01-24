//
//  FreeRunningMapView.swift
//  Outline
//
//  Created by hyebin on 1/22/24.
//
import MapKit
import SwiftUI

struct FreeRunningMapView: UIViewRepresentable {
    private let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        
        let region = MKCoordinateRegion(
            center: mapView.userLocation.coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}

#Preview {
    FreeRunningMapView()
}
