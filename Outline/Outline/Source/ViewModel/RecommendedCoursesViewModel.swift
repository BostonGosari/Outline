//
//  ViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import MapKit

class RecommendedCourseViewModel: ObservableObject {
    
    @Published var camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 36.01399, longitude: 129.34659), fromDistance: 1300, pitch: 0, heading: 0)
    @Published var centerLocation: CLLocationCoordinate2D?
    @Published var userLocation: CLLocationCoordinate2D?
    
    func distance(userLocation: CLLocationCoordinate2D, coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        userLocation.distance(to: coordinate)
    }
    
    func distanceFromCourse(userLocation: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D]) -> CLLocationDistance {
        var smallestDistance: CLLocationDistance = .greatestFiniteMagnitude

        for coordinate in coordinates {
            let distance = userLocation.distance(to: coordinate)

            if distance < smallestDistance {
                smallestDistance = distance
            }
        }
        return smallestDistance
    }
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let firstLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let secondLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return firstLocation.distance(from: secondLocation)
    }
}
