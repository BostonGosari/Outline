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
    
    @State private var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 36.0145128, longitude: 129.325619), CLLocationCoordinate2D(latitude: 36.014515, longitude: 129.3256147), CLLocationCoordinate2D(latitude: 36.0145165, longitude: 129.32561), CLLocationCoordinate2D(latitude: 36.0145176, longitude: 129.3256046), CLLocationCoordinate2D(latitude: 36.0145171, longitude: 129.3255986), CLLocationCoordinate2D(latitude: 36.014516, longitude: 129.3255926), CLLocationCoordinate2D(latitude: 36.0145139, longitude: 129.3255866), CLLocationCoordinate2D(latitude: 36.0145117, longitude: 129.3255802), CLLocationCoordinate2D(latitude: 36.0145071, longitude: 129.3255739), CLLocationCoordinate2D(latitude: 36.0145019, longitude: 129.3255708), CLLocationCoordinate2D(latitude: 36.0144965, longitude: 129.3255698), CLLocationCoordinate2D(latitude: 36.0144919, longitude: 129.3255697), CLLocationCoordinate2D(latitude: 36.0144873, longitude: 129.3255708), CLLocationCoordinate2D(latitude: 36.0144824, longitude: 129.3255728), CLLocationCoordinate2D(latitude: 36.0144775, longitude: 129.3255761), CLLocationCoordinate2D(latitude: 36.0144746, longitude: 129.3255805), CLLocationCoordinate2D(latitude: 36.0144713, longitude: 129.3255859), CLLocationCoordinate2D(latitude: 36.0144694, longitude: 129.3255922), CLLocationCoordinate2D(latitude: 36.0144694, longitude: 129.325598), CLLocationCoordinate2D(latitude: 36.0144694, longitude: 129.325605), CLLocationCoordinate2D(latitude: 36.0144702, longitude: 129.3256107), CLLocationCoordinate2D(latitude: 36.0144726, longitude: 129.3256187), CLLocationCoordinate2D(latitude: 36.0144753, longitude: 129.3256241), CLLocationCoordinate2D(latitude: 36.01448, longitude: 129.3256278), CLLocationCoordinate2D(latitude: 36.014484, longitude: 129.3256298), CLLocationCoordinate2D(latitude: 36.0144897, longitude: 129.3256311), CLLocationCoordinate2D(latitude: 36.0144935, longitude: 129.3256311), CLLocationCoordinate2D(latitude: 36.0144922, longitude: 129.3256251), CLLocationCoordinate2D(latitude: 36.0144919, longitude: 129.3256204), CLLocationCoordinate2D(latitude: 36.014493, longitude: 129.3256154), CLLocationCoordinate2D(latitude: 36.014496, longitude: 129.325613), CLLocationCoordinate2D(latitude: 36.0144995, longitude: 129.3256124), CLLocationCoordinate2D(latitude: 36.0145038, longitude: 129.325614), CLLocationCoordinate2D(latitude: 36.014507, longitude: 129.3256168), CLLocationCoordinate2D(latitude: 36.0145095, longitude: 129.3256221), CLLocationCoordinate2D(latitude: 36.0145128, longitude: 129.325619)]
    @State private var subCoordinates: [CLLocationCoordinate2D] =     [CLLocationCoordinate2D(latitude: 36.0145234, longitude: 129.3255816), CLLocationCoordinate2D(latitude: 36.0145253, longitude: 129.325586), CLLocationCoordinate2D(latitude: 36.0145278, longitude: 129.3255883), CLLocationCoordinate2D(latitude: 36.014531, longitude: 129.325589), CLLocationCoordinate2D(latitude: 36.0145346, longitude: 129.3255897), CLLocationCoordinate2D(latitude: 36.0145378, longitude: 129.3255887), CLLocationCoordinate2D(latitude: 36.014537, longitude: 129.3255853), CLLocationCoordinate2D(latitude: 36.0145348, longitude: 129.3255826), CLLocationCoordinate2D(latitude: 36.0145321, longitude: 129.3255806), CLLocationCoordinate2D(latitude: 36.0145294, longitude: 129.32558), CLLocationCoordinate2D(latitude: 36.0145264, longitude: 129.3255803), CLLocationCoordinate2D(latitude: 36.0145234, longitude: 129.3255816)]
    
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
                    Map(interactionModes: []) {
                        UserAnnotation()
                        MapPolyline(coordinates: coordinates)
                            .stroke(.customPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        MapPolyline(coordinates: subCoordinates)
                            .stroke(.customPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    }
                    .frame(height: 200)
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
    AppleRunDetailInformationView(showCopyLocationPopup: .constant(false))
}
