//
//  FreeRunningHomeView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import MapKit
import SwiftUI

struct FreeRunningHomeView: View {
    @StateObject private var viewModel = FreeRunningViewModel()
   
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.authState == .login {
                FreeRunningMapView()
                    .ignoresSafeArea()
                Color.gray800.opacity(0.8)
                    .ignoresSafeArea()
                    .blendMode(.multiply)
            }

            VStack(spacing: 0) {
                Header(title: "자유 아트", loading: false, scrollOffset: 20)
                    .padding(.top, 8)
                
                if viewModel.authState == .login {
                    Spacer()
                    cardView
                        .overlay {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("새로운 러닝 \(viewModel.freeRunCount == 0 ? "" : String(viewModel.freeRunCount + 1))")
                                    .font(.customHeadline)
                                    .padding(.bottom, 8)
                                HStack {
                                    Image(systemName: "mappin")
                                    Text(viewModel.userLocation)
                                }
                                .font(.customCaption)
                                .frame(height: 16)
                                SlideToUnlock(isUnlocked: $viewModel.isUnlocked, progress: $viewModel.progress)
                                    .onChange(of: viewModel.isUnlocked) { _, newValue in
                                        if newValue {
                                            if viewModel.runningStartManager.checkAuthorization() {
                                                viewModel.runningStartManager.start = true
                                                viewModel.runningStartManager.startFreeRun()

                                                let runningInfo = MirroringRunningInfo(runningType: .free, courseName: "자유아트", course: [])
                                                viewModel.connectivityManager.sendRunningInfo(runningInfo)
                                            }
                                            viewModel.isUnlocked = false
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
            viewModel.runningStartManager.getFreeRunNumber { result in
                switch result {
                case .success(let freeRunCount):
                    self.viewModel.freeRunCount = freeRunCount
                case .failure(let failure):
                    print("fail to load freeRunCount \(failure)")
                }
            }
        }
        .onChange(of: viewModel.runningStartManager.complete) { _, _ in
            viewModel.runningStartManager.getFreeRunNumber { result in
                switch result {
                case .success(let freeRunCount):
                    self.viewModel.freeRunCount = freeRunCount
                case .failure(let failure):
                    print("fail to load freeRunCount \(failure)")
                }
            }
        }
    }
}

extension FreeRunningHomeView {
    private var cardView: some View {
        UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70)
            .fill(.white5)
            .stroke(.white30)
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
                    
                    self.viewModel.userLocation = "\(area) \(city) \(town)"
                }
            }
        }
    }
}

#Preview {
    FreeRunningHomeView()
}
