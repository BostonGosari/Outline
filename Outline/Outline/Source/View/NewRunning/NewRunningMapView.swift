//
//  NewRunningMapView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import MapKit
import SwiftUI

struct NewRunningMapView: UIViewRepresentable {
    @StateObject private var runningStartManager = RunningStartManager.shared
    @StateObject private var runningDataManager = RunningDataManager.shared
    
    private let mapView = MKMapView()
    var userLocations: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        
        // tracking Button custom
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        mapView.addSubview(trackingButton)
        
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        trackingButton.trailingAnchor.constraint(equalTo: mapView.layoutMarginsGuide.trailingAnchor, constant: -16).isActive = true
        trackingButton.topAnchor.constraint(equalTo: mapView.layoutMarginsGuide.topAnchor, constant: 42).isActive = true
        trackingButton.backgroundColor = .black

        if let courseGuide = runningStartManager.startCourse {
            let polyline = MKPolyline(coordinates: ConvertCoordinateManager.convertToCLLocationCoordinates(courseGuide.coursePaths), count: courseGuide.coursePaths.count)
            mapView.addOverlay(polyline)
        }
    
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
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
        var parent: NewRunningMapView
        
        init(_ parent: NewRunningMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = (mapView.overlays.count == 1) ? UIColor(Color.black.opacity(0.3)) : .customPrimary
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

#Preview {
    NewRunningMapView(userLocations: [])
}
