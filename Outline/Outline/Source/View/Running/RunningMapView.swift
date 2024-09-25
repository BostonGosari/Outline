//
//  RunningMapView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import MapKit
import SwiftUI

struct RunningMapView: UIViewRepresentable {
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
        trackingButton.leadingAnchor.constraint(equalTo: mapView.layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
        trackingButton.bottomAnchor.constraint(equalTo: mapView.layoutMarginsGuide.bottomAnchor, constant: -92).isActive = true
        
        trackingButton.backgroundColor = .black
        
        if let courseGuide = runningStartManager.startCourse {
            let coordinates = courseGuide.coursePaths.toCLLocationCoordinates()
            let polyline = MKPolyline(coordinates: coordinates, count: courseGuide.coursePaths.count)
            mapView.addOverlay(polyline)
        }
    
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let smoothedLocations = smoothLocations(userLocations)
        
        if uiView.overlays.count >= 2,
           let overlay = uiView.overlays.last {
            uiView.removeOverlay(overlay)
        }
        
        if !smoothedLocations.isEmpty {
            let polyline = MKPolyline(
                coordinates: smoothedLocations,
                count: smoothedLocations.count
            )
            uiView.addOverlay(polyline)
        }
    }
    
    private func smoothLocations(_ locations: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        guard locations.count > 1 else { return locations }
        
        var smoothed: [CLLocationCoordinate2D] = []
        for i in 0..<locations.count {
            let start = max(0, i - 2)
            let end = min(locations.count - 1, i + 2)
            let subset = Array(locations[start...end])
            
            let avgLatitude = subset.map { $0.latitude }.reduce(0, +) / Double(subset.count)
            let avgLongitude = subset.map { $0.longitude }.reduce(0, +) / Double(subset.count)
            
            smoothed.append(CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude))
        }
        
        return smoothed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RunningMapView
        
        init(_ parent: RunningMapView) {
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
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if view.annotation is MKUserLocation {
                mapView.deselectAnnotation(view.annotation, animated: false)
                return
            }
        }
    }
}

#Preview {
    RunningMapView(userLocations: [])
}
