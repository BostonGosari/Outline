//
//  MirroringMapView.swift
//  Outline
//
//  Created by hyunjun on 11/22/23.
//

import MapKit
import SwiftUI

struct MirroringMapView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Namespace private var mapScope
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
                let userLocations = ConvertCoordinateManager.convertToCLLocationCoordinates(connectivityManager.runningData.userLocations)
                let course = ConvertCoordinateManager.convertToCLLocationCoordinates(connectivityManager.runningInfo.course)
                UserAnnotation()
                
                MapPolyline(coordinates: course)
                    .stroke(.black.opacity(0.3), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                
                MapPolyline(coordinates: userLocations)
                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            }
            .mapStyle(.standard(pointsOfInterest: []))
            .mapControlVisibility(.hidden)
            
            MapUserLocationButton(scope: mapScope)
                .buttonBorderShape(.circle)
                .tint(.white)
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 96)
                .padding(.leading, 16)
        }
        .mapScope(mapScope)
        .tint(.customPrimary)
    }
}

#Preview {
    MirroringMapView()
}
