//
//  FinishAppleRunView.swift
//  Outline
//
//  Created by hyunjun on 12/1/23.
//

import MapKit
import SwiftUI

struct AppleRunFinishView: View {
    @StateObject private var appleRunManager = AppleRunManager.shared
    @State private var navigateToShareView = false
    
    let userCoordinates = [CLLocationCoordinate2D(latitude: 36.0145573, longitude: 129.3256066), CLLocationCoordinate2D(latitude: 36.0145583, longitude: 129.3256006), CLLocationCoordinate2D(latitude: 36.0145586, longitude: 129.3255949), CLLocationCoordinate2D(latitude: 36.0145567, longitude: 129.3255882), CLLocationCoordinate2D(latitude: 36.0145534, longitude: 129.3255835), CLLocationCoordinate2D(latitude: 36.0145483, longitude: 129.3255805), CLLocationCoordinate2D(latitude: 36.0145429, longitude: 129.3255784), CLLocationCoordinate2D(latitude: 36.0145377, longitude: 129.3255788), CLLocationCoordinate2D(latitude: 36.0145334, longitude: 129.3255794), CLLocationCoordinate2D(latitude: 36.0145269, longitude: 129.3255828), CLLocationCoordinate2D(latitude: 36.0145223, longitude: 129.3255862), CLLocationCoordinate2D(latitude: 36.0145187, longitude: 129.3255895), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.3255919), CLLocationCoordinate2D(latitude: 36.0145128, longitude: 129.3255982), CLLocationCoordinate2D(latitude: 36.0145131, longitude: 129.3256049), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.32561), CLLocationCoordinate2D(latitude: 36.0145193, longitude: 129.3256133), CLLocationCoordinate2D(latitude: 36.014519, longitude: 129.3256167), CLLocationCoordinate2D(latitude: 36.0145168, longitude: 129.3256204), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.3256257), CLLocationCoordinate2D(latitude: 36.0145147, longitude: 129.3256304), CLLocationCoordinate2D(latitude: 36.0145158, longitude: 129.3256358), CLLocationCoordinate2D(latitude: 36.0145198, longitude: 129.3256402), CLLocationCoordinate2D(latitude: 36.0145238, longitude: 129.3256432), CLLocationCoordinate2D(latitude: 36.0145272, longitude: 129.3256455), CLLocationCoordinate2D(latitude: 36.014531, longitude: 129.3256475), CLLocationCoordinate2D(latitude: 36.0145364, longitude: 129.3256485), CLLocationCoordinate2D(latitude: 36.0145421, longitude: 129.3256495), CLLocationCoordinate2D(latitude: 36.0145472, longitude: 129.3256495), CLLocationCoordinate2D(latitude: 36.0145518, longitude: 129.3256475), CLLocationCoordinate2D(latitude: 36.0145559, longitude: 129.3256445), CLLocationCoordinate2D(latitude: 36.0145572, longitude: 129.3256395), CLLocationCoordinate2D(latitude: 36.0145586, longitude: 129.3256348), CLLocationCoordinate2D(latitude: 36.0145594, longitude: 129.3256294), CLLocationCoordinate2D(latitude: 36.0145591, longitude: 129.3256244), CLLocationCoordinate2D(latitude: 36.0145589, longitude: 129.3256197), CLLocationCoordinate2D(latitude: 36.0145578, longitude: 129.3256147), CLLocationCoordinate2D(latitude: 36.0145602, longitude: 129.3256113), CLLocationCoordinate2D(latitude: 36.0145651, longitude: 129.3256113), CLLocationCoordinate2D(latitude: 36.01457, longitude: 129.3256123), CLLocationCoordinate2D(latitude: 36.0145738, longitude: 129.3256143), CLLocationCoordinate2D(latitude: 36.0145781, longitude: 129.3256167), CLLocationCoordinate2D(latitude: 36.0145808, longitude: 129.3256214), CLLocationCoordinate2D(latitude: 36.0145827, longitude: 129.3256257), CLLocationCoordinate2D(latitude: 36.0145844, longitude: 129.3256311), CLLocationCoordinate2D(latitude: 36.0145819, longitude: 129.3256341), CLLocationCoordinate2D(latitude: 36.0145789, longitude: 129.3256334), CLLocationCoordinate2D(latitude: 36.0145757, longitude: 129.3256304), CLLocationCoordinate2D(latitude: 36.0145735, longitude: 129.3256267), CLLocationCoordinate2D(latitude: 36.0145724, longitude: 129.325622), CLLocationCoordinate2D(latitude: 36.0145711, longitude: 129.325618), CLLocationCoordinate2D(latitude: 36.0145703, longitude: 129.3256147)]
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            Circle()
                .frame(width: 350)
                .foregroundStyle(.customPrimary.opacity(0.35))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: -175, y: -100)
                .blur(radius: 120)
            Circle()
                .frame(width: 350)
                .foregroundStyle(.customPrimary.opacity(0.35))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 100, y: 100)
                .blur(radius: 120)
            
            VStack {
                BigCard(cardType: .excellent, runName: "애플런", date: "23 Apple Developer Academy FINAL SHOWCASE", editMode: false, time: "00:20", distance: "0.1KM", pace: "0'20''", kcal: "50", bpm: "120", score: 100) { } content: {
                    Image("AppleRunCardImage")
                        .resizable()
                }
                .padding(.top, 90)
                
                Spacer()
                
                CompleteButton(text: "자랑하기", isActive: true) {
//                    appleRunManager.running = false
                    appleRunManager.finish = false
                    navigateToShareView = true
                }
                .padding(.bottom, 16)
                
                Button(action: {
                    withAnimation {
                        appleRunManager.running = false
                        appleRunManager.finish = false
                        navigateToShareView = true
                    }
                }, label: {
                    Text("홈으로 돌아가기")
                        .underline(pattern: .solid)
                        .foregroundStyle(Color.gray300)
                        .font(.customSubbody)
                })
                .padding(.bottom, 8)
            }
        }
        .navigationDestination(isPresented: $navigateToShareView) {
            ShareView(runningData: ShareModel(courseName: "애플런", runningDate: "2023.12.4", regionDisplayName: "애플디벨로퍼아카데미", distance: "0.3", cal: "30", pace: "5'33''", bpm: "120", time: "00:20", userLocations: userCoordinates))
        }
    }
}

#Preview {
    AppleRunFinishView()
}
