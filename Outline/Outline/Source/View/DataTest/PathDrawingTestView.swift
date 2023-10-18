//
//  PathDrawingTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import SwiftUI

let dummyCoordinates = [
    CLLocationCoordinate2D(latitude: 36.0190178, longitude: 129.3434808),
    CLLocationCoordinate2D(latitude: 36.0190188, longitude: 129.3434838),
    CLLocationCoordinate2D(latitude: 36.0190198, longitude: 129.3434808),
    CLLocationCoordinate2D(latitude: 36.0190118, longitude: 129.3434800),
    CLLocationCoordinate2D(latitude: 36.0190408, longitude: 129.3434840)
]

let gradient = LinearGradient(colors: [Color.gradient1, Color.gradient3], startPoint: .top, endPoint: .bottom)

struct PathDrawingTestView: View {
    private let pathManager = PathGenerateManager.shared
    
    var body: some View {
        ZStack {
            Color.fourth
            pathManager
                .caculateLines(width: 300, height: 300, coordinates: dummyCoordinates)
                .stroke(Color.gradient3, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: 90))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PathDrawingTestView()
}
