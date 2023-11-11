//
//  MirroringMapView.swift
//  Outline
//
//  Created by hyunjun on 11/11/23.
//

import MapKit
import SwiftUI

struct MirroringMapView: View {
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Namespace var mapScope
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
                UserAnnotation()
            }
            .mapControlVisibility(.hidden)
            
            VStack(alignment: .trailing) {
                Rectangle()
                    .frame(width: 113, height: 168)
                    .foregroundStyle(.white.opacity(0.4))
                MapUserLocationButton(scope: mapScope)
                    .buttonBorderShape(.circle)
                    .tint(.white)
                    .controlSize(.large)
            }
            .padding(.top, 80)
            .padding(.trailing, 13)
        }
        .mapScope(mapScope)
    }
}

#Preview {
    MirroringMapView()
}
