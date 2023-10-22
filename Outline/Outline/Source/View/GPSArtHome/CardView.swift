//
//  CardView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI
import MapKit

struct CardView: View {
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    
    @Binding var isShow: Bool
    @Binding var currentIndex: Int
    var namespace: Namespace.ID
    var pageIndex: Int
    
    // 작은 카드의 사이즈
    let cardWidth: CGFloat = 318
    let cardHeight: CGFloat = 484
    
    var body: some View {
        courseImage
            .onTapGesture {
                withAnimation(.openCard) {
                    if homeTabViewModel.recommendedCoures.count == 3 {
                        isShow = true
                    }
                }
            }
            .overlay(alignment: .bottomLeading) {
                courseInformation
                    .opacity(currentIndex == pageIndex && !isShow ? 1 : 0)
                    .offset(y: currentIndex == pageIndex && !isShow ? 0 : 10)
                    .animation(.easeInOut(duration: 0.7), value: currentIndex == pageIndex)
            }
    }
    
    // MARK: - View Components
    
    private var courseImage: some View {
        Rectangle()
            .frame(width: cardWidth, height: cardHeight)
            .foregroundColor(.gray900Color)
            .roundedCorners(10, corners: [.topLeft])
            .roundedCorners(70, corners: [.topRight])
            .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
            .shadow(color: .white, radius: 0.5, y: -0.5)
            .matchedGeometryEffect(id: "courseImage\(pageIndex)", in: namespace)
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            if homeTabViewModel.recommendedCoures.count == 3 {
                Text("\(homeTabViewModel.recommendedCoures[pageIndex].course.courseName)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "mappin")
                    Text("\(homeTabViewModel.recommendedCoures[pageIndex].course.locationInfo.locality) \(homeTabViewModel.recommendedCoures[pageIndex].course.locationInfo.subLocality) • 내 위치에서 \(homeTabViewModel.recommendedCoures[pageIndex].distance/1000, specifier: "%.1f")km")
                }
                .font(.caption)
                .padding(.bottom, 16)
                
                HStack {
                    Text("#\(homeTabViewModel.recommendedCoures[pageIndex].course.courseLength, specifier: "%.0f")km")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                    Text("#\(formatDuration(homeTabViewModel.recommendedCoures[pageIndex].course.courseDuration))")
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                        }
                }
                .font(.caption)
                .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, 17)
        .padding(.bottom, 36)
    }
}

#Preview {
    HomeTabView()
}
