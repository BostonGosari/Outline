//
//  FreeRunningHomeView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct FreeRunningHomeView: View {
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    @StateObject var runningManager = RunningManager.shared
    @StateObject var locationManager = LocationManager()
    @ObservedObject var healthKitManager = HealthKitManager()
    @State var isPermissionSheetPresented: Bool = false
    @State var userLocation = ""
    @State var isUnlocked: Bool = false
    var body: some View {
        ZStack {
            FreeRunningMap(userLocation: $userLocation)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Header(scrollOffset: 20)
                    .padding(.top, 8)
                Spacer()
                
                cardView
                   .overlay {
                       VStack(alignment: .leading) {
                           Text("자유 코스")
                               .font(.headline)
                               .padding(.bottom, 8)
                           
                           HStack {
                               Image(systemName: "mappin")
                               Text(userLocation)
                           }
                           .font(.subBody)
                           
                           Spacer()
                           SlideToUnlock(isUnlocked: $isUnlocked)
                               .onChange(of: isUnlocked) { _, _ in
                                   if !locationManager.isAuthorized ||  !healthKitManager.isAuthorized {
                                       isPermissionSheetPresented = true
                                   } else {
                                       runningManager.startFreeRun()
                                       }
                                   }
                               }
                               .padding(-10)
                               .sheet(isPresented: $isPermissionSheetPresented) {
                                   if !locationManager.isAuthorized {
                                       PermissionSheetView(type: "location", ispresented: $isPermissionSheetPresented)
                                   } else {
                                       PermissionSheetView(type: "health", ispresented:  $isPermissionSheetPresented)
                               }
                       }
                       .padding(EdgeInsets(top: 58, leading: 24, bottom: 24, trailing: 16))
                   }
                   .padding(EdgeInsets(top: 8, leading: 16, bottom: 80, trailing: 20))
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension FreeRunningHomeView {
    private var cardView: some View {
        Rectangle()
            .fill(
                LinearGradient(colors: [.white20Color, .white20Color.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .roundedCorners(10, corners: [.topLeft])
            .roundedCorners(70, corners: [.topRight])
            .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
            .overlay(
                CustomRoundedRectangle(cornerRadiusTopLeft: 10, cornerRadiusTopRight: 79, cornerRadiusBottomLeft: 45, cornerRadiusBottomRight: 45)
            )
        
    }
}
