//
//  FinishRunningMap.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import MapKit
import SwiftUI

struct FinishRunningMap: UIViewRepresentable {
    @Binding var userLocations: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true
        
        let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
        mapView.addOverlay(polyline)
        
        if !userLocations.isEmpty {
            let region = MKCoordinateRegion(polyline.boundingMapRect)
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
        uiView.addOverlay(polyline)
        
        if !userLocations.isEmpty {
            let region = MKCoordinateRegion(polyline.boundingMapRect)
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: FinishRunningMap
        
        init(_ parent: FinishRunningMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKGradientPolylineRenderer(overlay: overlay)
            renderer.setColors([
                UIColor(hex: "#333349"),
                UIColor(hex: "#6478FF"),
                UIColor(hex: "#DBFB6C")
            ], locations: [])
            renderer.lineCap = .round
            renderer.lineWidth = 10
            return renderer
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.00)
      }
}
