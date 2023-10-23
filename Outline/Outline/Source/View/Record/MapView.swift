//
//  CourseDataView.swift
//  Outline
//
//  Created by 김하은 on 10/23/23.
//

import SwiftUI
import MapKit

struct CourseDataView: View {
    var courseData: CourseData

    var body: some View {
     
        MapView(coursePaths: courseData.coursePaths)
            .frame(height: 200)
            .cornerRadius(10)
   
    }
}

struct MapView: UIViewRepresentable {
    var coursePaths: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays) // Clear existing overlays

        if !coursePaths.isEmpty {
            let polyline = MKPolyline(coordinates: coursePaths, count: coursePaths.count)
            uiView.addOverlay(polyline)
            uiView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
