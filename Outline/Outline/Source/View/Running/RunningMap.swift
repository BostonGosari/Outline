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
        /*일시 중지 상태에서는 위치는 추적하지만 라인 그리는 것은 멈춤*/
        if viewModel.runningType == .start {
            
            /* 첫 번째 overlay인 kml 경로를 제외하고 마지막 overlay 삭제 */
            if uiView.overlays.count >= 2,
               let overlay = uiView.overlays.last {
                uiView.removeOverlay(overlay)
            }
            
            /* 사용자의 위치가 바꼈다면 polyline을 그림 */
            if !locationManager.userLocations.isEmpty {
                let polyline = MKPolyline(
                    coordinates: locationManager.userLocations,
                    count: locationManager.userLocations.count
                )
                uiView.addOverlay(polyline)
            }
        }
        
        /* 상위 View의 버튼이 클릭되면 현재 사용자 위치를 center로 위도, 경도 200미터 범위로 region을 변경 */
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
                renderer.strokeColor = (mapView.overlays.count == 1) ? .gray600 : .primary
                renderer.lineWidth = 15
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
