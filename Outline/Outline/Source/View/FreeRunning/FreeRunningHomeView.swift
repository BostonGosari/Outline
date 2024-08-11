//
//  FreeRunningHomeView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import MapKit
import SwiftUI

struct FreeRunningHomeView: View {
    @AppStorage("authState") var authState: AuthState = .logout
    @StateObject private var connectivityManager = ConnectivityManager.shared
    @StateObject var runningStartManager = RunningStartManager.shared
    
    @State private var userLocation = ""
    @State private var progress: Double = 0.0
    @State private var showPermissionSheet = false
    @State private var isUnlocked = false
    @State private var permissionType: PermissionType = .health
    @State private var freeRunCount: Int = 0
   
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray900
                .ignoresSafeArea()
            if authState == .login {
                FreeRunningMapView()
                    .ignoresSafeArea()
                Color.gray900
                    .ignoresSafeArea()
                    .opacity(0.85)
            }
            
            BackgroundBlur(color: Color.customSecondary, padding: 50)
                .opacity(0.5)

            VStack(spacing: 0) {
                GPSArtHomeHeader(title: "자유 아트", loading: false, scrollOffset: 20)
                    .padding(.top, 8)
                
                if authState == .login {
                    Spacer()
                    cardView
                        .overlay {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("새로운 러닝 \(freeRunCount == 0 ? "" : String(freeRunCount + 1))")
                                    .font(.customHeadline)
                                    .padding(.bottom, 8)
                                HStack {
                                    Image(systemName: "mappin")
                                    Text(userLocation)
                                }
                                .font(.customCaption)
                                .frame(height: 16)
                                SlideToUnlock(isUnlocked: $isUnlocked, progress: $progress)
                                    .onChange(of: isUnlocked) { _, newValue in
                                        if newValue {
                                            if runningStartManager.checkAuthorization() {
                                                runningStartManager.start = true
                                                runningStartManager.startFreeRun()
                                                
                                                let runningInfo = MirroringRunningInfo(runningType: .free, courseName: "자유아트", course: [])
                                                connectivityManager.sendRunningInfo(runningInfo)
                                            }
                                            isUnlocked = false
                                        }
                                    }
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                            }
                            .padding(EdgeInsets(top: 58, leading: 24, bottom: 24, trailing: 16))
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 80, trailing: 20))
                } else {
                    Spacer()
                    LookAroundView(type: .running)
                    Spacer()
                }
            }
        }
        .onAppear {
            userLocationToString()
            runningStartManager.getFreeRunNumber { result in
                switch result {
                case .success(let freeRunCount):
                    self.freeRunCount = freeRunCount
                case .failure(let failure):
                    print("fail to load freeRunCount \(failure)")
                }
            }
        }
        .onChange(of: runningStartManager.complete) { _, _ in
            runningStartManager.getFreeRunNumber { result in
                switch result {
                case .success(let freeRunCount):
                    self.freeRunCount = freeRunCount
                case .failure(let failure):
                    print("fail to load freeRunCount \(failure)")
                }
            }
        }
    }
}

extension FreeRunningHomeView {
    private var cardView: some View {
        Rectangle()
            .fill(.white7)
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

#Preview {
    FreeRunningHomeView()
}
