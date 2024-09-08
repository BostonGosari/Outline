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
    private var locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        locationManager.delegate = context.coordinator
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        
        let configuration = MKStandardMapConfiguration(emphasisStyle: .muted)
        mapView.preferredConfiguration = configuration
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: FreeRunningMapView
        
        init(_ parent: FreeRunningMapView) {
            self.parent = parent
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                parent.mapView.setRegion(region, animated: true)
            }
        }
    }
}
