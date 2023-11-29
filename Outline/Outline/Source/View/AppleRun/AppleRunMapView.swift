//
//  AppleRunMapView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import MapKit
import SwiftUI

struct AppleRunMapView: View {
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Namespace private var mapScope
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
//                UserAnnotation()
                
//                MapPolyline(coordinates: course)
//                    .stroke(.black.opacity(0.3), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
//                
//                MapPolyline(coordinates: userLocations)
//                    .stroke(.customPrimary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
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
    AppleRunMapView()
}
