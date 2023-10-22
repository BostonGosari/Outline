//
//  CardDetailInformationView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit

struct CardDetailInformationView: View {
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    var currentIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("#\(stringForCourseLevel(homeTabViewModel.recommendedCoures[currentIndex].course.level))")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                    .foregroundColor(.primaryColor)
                Text("\(homeTabViewModel.recommendedCoures[currentIndex].course.courseLength, specifier: "%.0f")km")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                Text("\(formatDuration(homeTabViewModel.recommendedCoures[currentIndex].course.courseDuration))")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
            }
            .fontWeight(.semibold)
            .font(.caption)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(homeTabViewModel.recommendedCoures[currentIndex].course.locationInfo.administrativeArea) \(homeTabViewModel.recommendedCoures[currentIndex].course.locationInfo.locality) \(homeTabViewModel.recommendedCoures[currentIndex].course.locationInfo.subLocality)")
                    .font(.title3)
                    .bold()
                Text("--")
                    .foregroundStyle(.gray)
            }
            
            Divider()
            
            Text("경로 정보")
                .font(.title3)
                .bold()
            VStack(alignment: .leading, spacing: 17) {
                HStack {
                    HStack {
                        Image(systemName: "location")
                        Text("거리")
                    }
                    .foregroundColor(.primaryColor)
                    Text("\(homeTabViewModel.recommendedCoures[currentIndex].course.courseLength, specifier: "%.0f")km")
                }
                HStack {
                    HStack {
                        Image(systemName: "clock")
                        Text("예상 소요 시간")
                    }
                    .foregroundColor(.primaryColor)
                    Text("\(formatDuration(homeTabViewModel.recommendedCoures[currentIndex].course.courseDuration))")
                }
                HStack {
                    HStack {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond")
                        Text("골목길")
                    }
                    .foregroundColor(.primaryColor)
                    Text(stringForAlley(homeTabViewModel.recommendedCoures[currentIndex].course.alley))
                }
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            Text("경로 지도")
                .font(.title3)
                .bold()
            VStack(alignment: .leading) {
                MapInfoView(camera: MKMapCamera(
                    lookingAtCenter: convertToCLLocationCoordinate(homeTabViewModel.recommendedCoures[currentIndex].course.centerLocation),
                    fromDistance: 1000, pitch: 0, heading: 0), coordinates: convertToCLLocationCoordinates(homeTabViewModel.recommendedCoures[currentIndex].course.coursePaths)
                )
                .frame(height: 200)
                .foregroundStyle(.thinMaterial)
                Text("경로 제작 고사리님 @alsgiwc")
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
}
