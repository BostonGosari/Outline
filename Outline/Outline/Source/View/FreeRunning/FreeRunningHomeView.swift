//
//  FreeRunningHomeView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import MapKit
import SwiftUI

struct FreeRunningHomeView: View {
    @StateObject var runningManager = RunningManager.shared
    
    @State private var userLocation = ""
    @State private var progress: Double = 0.0
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
   
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position)
        
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, maxHeight: 358)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.02, green: 0.01, blue: 0.15).opacity(0.4), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.09, green: 0.07, blue: 0.39).opacity(0), location: 1.00)
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.6))
            
            VStack(spacing: 0) {
                Header(loading: false, scrollOffset: 20)
                    .padding(.top, 8)
                Spacer()
                
                cardView
                   .overlay {
                       VStack(alignment: .leading) {
                           Text("자유코스")
                               .font(.headline)
                               .padding(.bottom, 8)
                           
                           HStack {
                               Image(systemName: "mappin")
                               Text(userLocation)
                           }
                           .font(.subBody)
                           
                           Spacer()
                           SlideToUnlock(isUnlocked: $runningManager.start, progress: $progress)
                               .onChange(of: runningManager.start) { _, _ in
                                   runningManager.startFreeRun()
                               }
                       }
                       .padding(EdgeInsets(top: 58, leading: 24, bottom: 24, trailing: 16))
                   }
                   .padding(EdgeInsets(top: 8, leading: 16, bottom: 80, trailing: 20))
            }
        }
        .onAppear {
            userLocationToString()
        }
    }
}

extension FreeRunningHomeView {
    private var cardView: some View {
        Rectangle()
            .fill(
                LinearGradient(colors: [.white20, .white20.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .roundedCorners(10, corners: [.topLeft])
            .roundedCorners(70, corners: [.topRight])
            .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
            .overlay(
                CustomRoundedRectangle(cornerRadiusTopLeft: 10, cornerRadiusTopRight: 79, cornerRadiusBottomLeft: 45, cornerRadiusBottomRight: 45)
            )
    }
    
    private func userLocationToString() {
        let locationManger = CLLocationManager()
        if let location = locationManger.location {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let area = placemark.administrativeArea ?? ""
                    let city = placemark.locality ?? ""
                    let town = placemark.subLocality ?? ""
                    
                    self.userLocation = "\(area) \(city) \(town)"
                }
            }
        }
    }
}
