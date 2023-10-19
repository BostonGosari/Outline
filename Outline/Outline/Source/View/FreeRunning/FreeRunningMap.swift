//
//  FreeRunningMap.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import MapKit
import SwiftUI

struct FreeRunningMap: UIViewRepresentable {
    
    @Binding var userLocation: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.showsCompass = false
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: FreeRunningMap
        
        init(_ parent: FreeRunningMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if let userLocation = userLocation.location {
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(userLocation) { placemarks, error in
                    if let error = error {
                        print("Reverse geocoding error: \(error.localizedDescription)")
                    } else if let placemark = placemarks?.first {
                        let area = placemark.administrativeArea ?? ""
                        let city = placemark.locality ?? ""
                        let town = placemark.subLocality ?? ""
                        
                        self.parent.userLocation = "\(area) \(city) \(town)"
                    }
                }
            }
       }
    }
}
