//
//  AccuracyCheckView.swift
//  Outline
//
//  Created by Seungui Moon on 11/14/23.
//

import MapKit
import SwiftUI

struct AccuracyCheckView: View {
    @StateObject private var accuracyCheckViewModel = AccuracyCheckViewModel()
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation()
                MapPolyline(coordinates: coordinatesToCLLocationCoordiantes(coordinates: accuracyCheckViewModel.gpsCourses.coursePaths))
                    .stroke(.gray200.opacity(0.5), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                MapPolyline(coordinates: accuracyCheckViewModel.userLocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            }
            VStack {
                Spacer()
                Text("\(accuracyCheckViewModel.accuracy)")
                Text("\(accuracyCheckViewModel.progress)")
                Button {
                    accuracyCheckViewModel.caculateAccuracyAndProgress()
                } label: {
                    Text("finish running")
                }
                Button {
                    accuracyCheckViewModel.resetRunning()
                } label: {
                    Text("reset running")
                }
            }
        }
//        .onChange(of: CLLocationManager().location, { _, newValue in
//            if let newUserLocation = newValue?.coordinate {
//                accuracyCheckViewModel.userLocations.append(newUserLocation)
//            }
//        })
        .onAppear {
            accuracyCheckViewModel.getCourses()
        }
    }
    
    private func coordinatesToCLLocationCoordiantes(coordinates: [Coordinate]) -> [CLLocationCoordinate2D] {
        var clLocations: [CLLocationCoordinate2D] = []
        for coordinate in accuracyCheckViewModel.gpsCourses.coursePaths {
            clLocations.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        return clLocations
    }
}

#Preview {
    AccuracyCheckView()
}
