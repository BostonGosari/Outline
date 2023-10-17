//
//  WatchMapView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import MapKit

struct MapWatchView: View {
    
    let locationManager = CLLocationManager()
    
    @State private var coordinates = [
        CLLocationCoordinate2D(latitude: 36.01440, longitude: 129.34640),
        CLLocationCoordinate2D(latitude: 36.01378, longitude: 129.34770),
        CLLocationCoordinate2D(latitude: 36.01324, longitude: 129.34728),
        CLLocationCoordinate2D(latitude: 36.01390, longitude: 129.34603)
    ]
    
    @State var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    @State private var userLocations: [CLLocationCoordinate2D] = []
    
    @State private var userCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationStack {
            Map(position: $position, interactionModes: .zoom) {
                UserAnnotation(anchor: .center) { userlocation in
                    ZStack {
                        Circle().foregroundStyle(.white).frame(width: 24)
                        Circle().foregroundStyle(.green).frame(width: 18)
                    }
                    .onChange(of: userlocation.location) { _, userlocation in
                        if let user = userlocation {
                            userLocations.append(user.coordinate)
                        }
                    }
                }
                MapPolyline(coordinates: coordinates)
                    .stroke(.gray.opacity(0.5), lineWidth: 8)
                MapPolyline(coordinates: userLocations)
                    .stroke(.green, lineWidth: 8)
            }
            .mapControls {
                MapUserLocationButton()
            }
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }
            .tint(.green)
            .overlay(alignment: .topLeading) {
                Text("시티런")
                    .bold()
                    .foregroundStyle(.green)
                    .padding()
                    .padding(.top, 5)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        Rectangle()
                            .foregroundStyle(.thinMaterial)
                    }
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    MapWatchView()
}
