//
//  MirroringMapView.swift
//  Outline
//
//  Created by hyunjun on 11/10/23.
//

import SwiftUI
import MapKit

struct MirroringMapView: View {
    
    var body: some View {
        Map {
            UserAnnotation()
        }
    }
}

#Preview {
    MirroringMapView()
}
