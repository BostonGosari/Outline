//
//  CardDetailInformationView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CardDetailInformationView: View {
    
    @ObservedObject var vm: GPSArtHomeViewModel
    var currentIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("#\(stringForCourseLevel(vm.recommendedCoures[currentIndex].course.level))")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                    .foregroundColor(.primaryColor)
                Text("\(vm.recommendedCoures[currentIndex].course.courseLength, specifier: "%.0f")km")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                Text("\(formatDuration(vm.recommendedCoures[currentIndex].course.courseDuration))")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
            }
            .fontWeight(.semibold)
            .font(.caption)
                        
            VStack(alignment: .leading, spacing: 8) {
                Text("\(vm.recommendedCoures[currentIndex].course.locationInfo.administrativeArea) \(vm.recommendedCoures[currentIndex].course.locationInfo.locality) \(vm.recommendedCoures[currentIndex].course.locationInfo.subLocality)")
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
                    Text("\(vm.recommendedCoures[currentIndex].course.courseLength, specifier: "%.0f")km")
                }
                HStack {
                    HStack {
                        Image(systemName: "clock")
                        Text("예상 소요 시간")
                    }
                    .foregroundColor(.primaryColor)
                    Text("\(formatDuration(vm.recommendedCoures[currentIndex].course.courseDuration))")
                }
                HStack {
                    HStack {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond")
                        Text("골목길")
                    }
                    .foregroundColor(.primaryColor)
                    Text(stringForAlley(vm.recommendedCoures[currentIndex].course.alley))
                }
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            Text("경로 지도")
                .font(.title3)
                .bold()
            VStack(alignment: .leading) {
                Rectangle()
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
