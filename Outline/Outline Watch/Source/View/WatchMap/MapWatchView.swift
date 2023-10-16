//
//  WatchMapView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import MapKit

struct MapWatchView: View {
    
    @State private var coordinates = [
        CLLocationCoordinate2D(latitude: 36.01440, longitude: 129.34640),
        CLLocationCoordinate2D(latitude: 36.01378, longitude: 129.34770),
        CLLocationCoordinate2D(latitude: 36.01324, longitude: 129.34728),
        CLLocationCoordinate2D(latitude: 36.01390, longitude: 129.34603)
    ]
    
    var body: some View {
        VStack {
            Map {
                UserAnnotation(anchor: .center)
                MapPolyline(coordinates: coordinates)
            }
        }
    }
}

#Preview {
    MapWatchView()
}
