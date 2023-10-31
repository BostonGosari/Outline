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
    
    @State private var userMoveMap = false
    
    private let mapView = MKMapView()
    var coordinates: [CLLocationCoordinate2D]
   
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        mapView.isZoomEnabled = true
        mapView.showsCompass = false
        mapView.setUserTrackingMode(.follow, animated: true)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTapGesture(_:)))
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePanGesture(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPressGesture(_:)))
        
        mapView.addGestureRecognizer(panGesture)
        mapView.addGestureRecognizer(tapGesture)
        mapView.addGestureRecognizer(longPressGesture)
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if viewModel.runningType == .start {
            
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
            uiView.setUserTrackingMode(.follow, animated: true)
            uiView.isZoomEnabled = true
            DispatchQueue.main.async {
                userMoveMap = false
            }
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
                renderer.strokeColor = (mapView.overlays.count == 1) ? .gray600 : .customBlack
                renderer.lineWidth = 7
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            if !parent.userMoveMap {
                mapView.setUserTrackingMode(.follow, animated: true)
            }
        }
        
        @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
            if gesture.state == .ended {
                parent.userMoveMap = true
            }
        }
        
        @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            if gesture.state == .began {
                parent.userMoveMap = true
            }
        }
        
        @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                parent.userMoveMap = true
            }
        }
    }
}
