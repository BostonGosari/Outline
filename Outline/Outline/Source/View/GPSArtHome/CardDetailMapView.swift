//
//  CardDetailMapView.swift
//  Outline
//
//  Created by hyebin on 1/22/24.
//

import MapKit
import SwiftUI

struct CardDetailMapView: UIViewRepresentable {
    @Binding var places: [Place]
    @Binding var selectedAnnotation: SpotAnnotation?
    
    private let mapView = MKMapView()
    let coursePaths: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        
        let polyline = MKPolyline(coordinates: coursePaths, count: coursePaths.count)
        let edgePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePadding, animated: false)
        mapView.addOverlay(polyline)
    
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        for place in places {
            let annotation = SpotAnnotation(
                title: place.title, 
                subtitle: place.spotDescription,
                image: UIImage(systemName: "flag.fill"),
                coordinate: place.location
            )
            mapView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CardDetailMapView
        
        init(_ parent: CardDetailMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .customPrimary
            renderer.lineWidth = 8
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let spotAnnotation = view.annotation as? SpotAnnotation {
                parent.selectedAnnotation = spotAnnotation
            }
        }
    }
}

class SpotAnnotationView: MKAnnotationView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        guard let spotAnnotation = self.annotation as? SpotAnnotation else {
            return
        }
        
        image = spotAnnotation.image
        self.backgroundColor = annotation?.title == "시작 위치" ? .red : .customPrimary
    }
}

class SpotAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let image: UIImage?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.coordinate = coordinate
    }
}

#Preview {
    CardDetailMapView(places: .constant([]), selectedAnnotation: .constant(nil), coursePaths: [])
}
