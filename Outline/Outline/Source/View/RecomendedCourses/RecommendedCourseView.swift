//
//  RecommendedCourseView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit

struct RecommendedCoursesView: View {
    
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel = RecommendedCourseViewModel()
    
    var body: some View {
        VStack {
            RecomendedCourseMap(
                userLocation: $viewModel.userLocation,
                camera: viewModel.camera
            )
                .frame(width: 400, height: 400)
                .onAppear {
                    locationManager.requestLocation()
                }
            if let userLocation = viewModel.userLocation {
                Text("\(userLocation.latitude)")
                Text("\(userLocation.longitude)")
                Text("\(viewModel.distance(userLocation: userLocation, coordinate: CLLocationCoordinate2D(latitude: 36.01404, longitude: 129.32594)))m")
            }
        }
    }
}

#Preview {
    RecommendedCoursesView()
}
