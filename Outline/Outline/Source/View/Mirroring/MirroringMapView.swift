//
//  MirroringMapView.swift
//  Outline
//
//  Created by hyunjun on 11/22/23.
//

import MapKit
import SwiftUI

struct MirroringMapView: UIViewRepresentable {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    private let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        
        // tracking Button custom
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        mapView.addSubview(trackingButton)
        
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        trackingButton.leadingAnchor.constraint(equalTo: mapView.layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
        trackingButton.bottomAnchor.constraint(equalTo: mapView.layoutMarginsGuide.bottomAnchor, constant: -92).isActive = true
        
        trackingButton.backgroundColor = .black
        trackingButton.tintColor = UIColor(.customPrimary)
        
        let course = ConvertCoordinateManager.convertToCLLocationCoordinates(connectivityManager.runningInfo.course)
        
        let polyline = MKPolyline(coordinates: course, count: course.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let userLocations = ConvertCoordinateManager.convertToCLLocationCoordinates(connectivityManager.runningData.userLocations)
        
        if uiView.overlays.count >= 2,
           let overlay = uiView.overlays.last {
            uiView.removeOverlay(overlay)
        }
        
        if !userLocations.isEmpty {
            let polyline = MKPolyline(
                coordinates: userLocations,
                count: userLocations.count
            )
            uiView.addOverlay(polyline)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MirroringMapView
        
        init(_ parent: MirroringMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = (mapView.overlays.count == 1) ? UIColor(Color.white.opacity(0.5)) : .customPrimary
                renderer.lineWidth = (mapView.overlays.count == 1) ? 8  : 5
                renderer.lineCap = .round
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

#Preview {
    MirroringMapView()
}
