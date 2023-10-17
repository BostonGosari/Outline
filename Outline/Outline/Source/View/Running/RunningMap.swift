//
//  RunningMapView.swift
//  Outline
//
//  Created by hyebin on 10/17/23.
//

import MapKit
import SwiftUI

struct RunningMap: UIViewRepresentable {
    
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var viewModel: RunningMapViewModel
    
    private let mapView = MKMapView()
    var coordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.isZoomEnabled = true
        mapView.showsCompass = false
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if viewModel.runningType == .running {
            if uiView.overlays.count >= 2,
               let overlay = uiView.overlays.last {
                uiView.removeOverlay(overlay)
            }
            
            if !locationManager.userLocations.isEmpty {
                let polyline = MKPolyline(
                    coordinates: locationManager.userLocations,
                    count: locationManager.userLocations.count
                )
                uiView.addOverlay(polyline)
            }
        }
        
        if viewModel.isUserLocationCenter {
            let userLocation = uiView.userLocation

            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                latitudinalMeters: 200,
                longitudinalMeters: 200
            )
            uiView.setRegion(region, animated: true)
            uiView.setUserTrackingMode(.followWithHeading, animated: true)
            uiView.isZoomEnabled = true
            
            viewModel.isUserLocationCenter = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RunningMap
        
        init(_ parent: RunningMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = (mapView.overlays.count == 1) ? .gray600 : .first
                renderer.lineWidth = 15
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
