//
//  WatchMapView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import MapKit

struct MapWatchView: View {
    
    var course: [CLLocationCoordinate2D] = []
    
    @State var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    @Binding var userLocations: [CLLocationCoordinate2D]
    
    @State private var userCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationStack {
            Map(position: $position, interactionModes: .zoom) {
                UserAnnotation(anchor: .center) { userlocation in
                    ZStack {
                        Circle().foregroundStyle(.white).frame(width: 22)
                        Circle().foregroundStyle(.first).frame(width: 17)
                        Circle().foregroundStyle(.black).frame(width: 15)
                    }
                    .onChange(of: userlocation.location) { _, userlocation in
                        if let user = userlocation {
                            userLocations.append(user.coordinate)
                        }
                    }
                }
                MapPolyline(coordinates: course)
                    .stroke(.gray.opacity(0.5), lineWidth: 8)
                MapPolyline(coordinates: userLocations)
                    .stroke(.first, lineWidth: 8)
            }
            .mapControlVisibility(.hidden)
            .tint(.first)
            .overlay(alignment: .topLeading) {
                Text("시티런")
                    .bold()
                    .foregroundStyle(.first)
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
