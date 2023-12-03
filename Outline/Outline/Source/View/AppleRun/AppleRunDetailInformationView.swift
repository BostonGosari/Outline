//
//  AppleRunDetailInformationView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import MapKit
import SwiftUI

struct AppleRunDetailInformationView: View {
    @Binding var showCopyLocationPopup: Bool
    
    @State private var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 36.0145573, longitude: 129.3256066), CLLocationCoordinate2D(latitude: 36.0145583, longitude: 129.3256006), CLLocationCoordinate2D(latitude: 36.0145586, longitude: 129.3255949), CLLocationCoordinate2D(latitude: 36.0145567, longitude: 129.3255882), CLLocationCoordinate2D(latitude: 36.0145534, longitude: 129.3255835), CLLocationCoordinate2D(latitude: 36.0145483, longitude: 129.3255805), CLLocationCoordinate2D(latitude: 36.0145429, longitude: 129.3255784), CLLocationCoordinate2D(latitude: 36.0145377, longitude: 129.3255788), CLLocationCoordinate2D(latitude: 36.0145334, longitude: 129.3255794), CLLocationCoordinate2D(latitude: 36.0145269, longitude: 129.3255828), CLLocationCoordinate2D(latitude: 36.0145223, longitude: 129.3255862), CLLocationCoordinate2D(latitude: 36.0145187, longitude: 129.3255895), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.3255919), CLLocationCoordinate2D(latitude: 36.0145128, longitude: 129.3255982), CLLocationCoordinate2D(latitude: 36.0145131, longitude: 129.3256049), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.32561), CLLocationCoordinate2D(latitude: 36.0145193, longitude: 129.3256133), CLLocationCoordinate2D(latitude: 36.014519, longitude: 129.3256167), CLLocationCoordinate2D(latitude: 36.0145168, longitude: 129.3256204), CLLocationCoordinate2D(latitude: 36.0145152, longitude: 129.3256257), CLLocationCoordinate2D(latitude: 36.0145147, longitude: 129.3256304), CLLocationCoordinate2D(latitude: 36.0145158, longitude: 129.3256358), CLLocationCoordinate2D(latitude: 36.0145198, longitude: 129.3256402), CLLocationCoordinate2D(latitude: 36.0145238, longitude: 129.3256432), CLLocationCoordinate2D(latitude: 36.0145272, longitude: 129.3256455), CLLocationCoordinate2D(latitude: 36.014531, longitude: 129.3256475), CLLocationCoordinate2D(latitude: 36.0145364, longitude: 129.3256485), CLLocationCoordinate2D(latitude: 36.0145421, longitude: 129.3256495), CLLocationCoordinate2D(latitude: 36.0145472, longitude: 129.3256495), CLLocationCoordinate2D(latitude: 36.0145518, longitude: 129.3256475), CLLocationCoordinate2D(latitude: 36.0145559, longitude: 129.3256445), CLLocationCoordinate2D(latitude: 36.0145572, longitude: 129.3256395), CLLocationCoordinate2D(latitude: 36.0145586, longitude: 129.3256348), CLLocationCoordinate2D(latitude: 36.0145594, longitude: 129.3256294), CLLocationCoordinate2D(latitude: 36.0145591, longitude: 129.3256244), CLLocationCoordinate2D(latitude: 36.0145589, longitude: 129.3256197), CLLocationCoordinate2D(latitude: 36.0145578, longitude: 129.3256147), CLLocationCoordinate2D(latitude: 36.0145602, longitude: 129.3256113), CLLocationCoordinate2D(latitude: 36.0145651, longitude: 129.3256113), CLLocationCoordinate2D(latitude: 36.01457, longitude: 129.3256123), CLLocationCoordinate2D(latitude: 36.0145738, longitude: 129.3256143), CLLocationCoordinate2D(latitude: 36.0145781, longitude: 129.3256167), CLLocationCoordinate2D(latitude: 36.0145808, longitude: 129.3256214), CLLocationCoordinate2D(latitude: 36.0145827, longitude: 129.3256257), CLLocationCoordinate2D(latitude: 36.0145844, longitude: 129.3256311), CLLocationCoordinate2D(latitude: 36.0145819, longitude: 129.3256341), CLLocationCoordinate2D(latitude: 36.0145789, longitude: 129.3256334), CLLocationCoordinate2D(latitude: 36.0145757, longitude: 129.3256304), CLLocationCoordinate2D(latitude: 36.0145735, longitude: 129.3256267), CLLocationCoordinate2D(latitude: 36.0145724, longitude: 129.325622), CLLocationCoordinate2D(latitude: 36.0145711, longitude: 129.325618), CLLocationCoordinate2D(latitude: 36.0145703, longitude: 129.3256147)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("애플 디벨로퍼 아카데미 쇼케이스 러닝코스")
                .multilineTextAlignment(.leading)
                .font(.customSubtitle2)
                .foregroundStyle(.customWhite)
                .padding(.vertical, 4)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
            
            Text("경로 정보")
                .font(.customSubtitle)
                .fontWeight(.semibold)
                .padding(.bottom, 6)
            VStack(alignment: .leading, spacing: 17) {
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "flag")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("시작 위치")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("애플 디벨로퍼 아카데미")
                        .font(.customTag)
                        .fontWeight(.semibold)
                    Text("복사")
                        .font(.customTag)
                        .foregroundStyle(.gray500)
                        .onTapGesture {
                            copyLocation()
                        }
                }
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 16))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("난이도")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            if index < countForCourseLevel(.easy) {
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(.customWhite)
                                    .frame(width: 8, height: 16)
                            } else {
                                RoundedRectangle(cornerRadius: 1)
                                    .foregroundColor(.clear)
                                    .frame(width: 8, height: 16)
                                    .background(.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 1)
                                            .inset(by: 0.1)
                                            .stroke(.white.opacity(0.3), lineWidth: 0.2)
                                    )
                            }
                        }
                    }
                }
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "location")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("거리")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("0.1km")
                        .font(.customSubbody)
                }
                HStack {
                    HStack {
                        Group {
                            Image(systemName: "clock")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(width: 20)
                        Text("예상 소요 시간")
                            .font(.customTag)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.customPrimary)
                    Text("3분대")
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 12)
            
            Divider()
            
            Text("경로 지도")
                .font(.customSubtitle)
                .fontWeight(.semibold)
            VStack(alignment: .leading, spacing: 8) {
                NavigationLink {
                        Map {
                            UserAnnotation()
                            MapPolyline(coordinates: coordinates)
                                .stroke(.customPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                            Marker("애플 디벨로퍼 아카데미", coordinate: CLLocationCoordinate2D(latitude: 36.01451, longitude: 129.32560))
                                .tint(.customRed)
                        }
                } label: {
                    Map(interactionModes: []) {
                        UserAnnotation()
                        MapPolyline(coordinates: coordinates)
                            .stroke(.customPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    }
                    .frame(height: 200)
                }
                
                Text("경로 제작 보스턴고사리")
                    .font(.customSubbody)
                    .foregroundStyle(.gray600)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
    
    private func countForCourseLevel(_ level: CourseLevel) -> Int {
        switch level {
        case .easy:
            return 1
        case .normal:
            return 3
        case .hard:
            return 5
        }
    }
    
    private func copyLocation() {
        UIPasteboard.general.string = "애플디벨로퍼아카데미"
        showCopyLocationPopup = true
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
            self.showCopyLocationPopup = false
        }
    }
}

#Preview {
    NavigationStack {
        AppleRunDetailInformationView(showCopyLocationPopup: .constant(false))
            .tint(.customPrimary)
    }
}
