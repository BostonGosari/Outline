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
            .overlay(alignment: .bottom) {
                courseInformation
                    .opacity(currentIndex == pageIndex && !isShow ? 1 : 0)
                    .offset(y: currentIndex == pageIndex && !isShow ? 0 : 10)
                    .animation(.easeInOut(duration: 0.7), value: currentIndex == pageIndex)
                   
            }
    }
    
    // MARK: - View Components
    private var courseImage: some View {
        if pageIndex < homeTabViewModel.recommendedCoures.count {
            return AnyView(
                AsyncImage(url: URL(string: homeTabViewModel.recommendedCoures[pageIndex].course.thumbnail)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray900Color)
                }
                .frame(width: cardWidth, height: cardHeight)
                .roundedCorners(10, corners: [.topLeft])
                .roundedCorners(70, corners: [.topRight])
                .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
                .shadow(color: .white, radius: 0.5, y: -0.5)
                .matchedGeometryEffect(id: "courseImage\(pageIndex)", in: namespace)
            )
        } else {
            return AnyView(
                Rectangle()
                    .frame(width: cardWidth, height: cardHeight)
                    .foregroundColor(.gray900Color)
                    .roundedCorners(10, corners: [.topLeft])
                    .roundedCorners(70, corners: [.topRight])
                    .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: .white, radius: 0.5, y: -0.5)
                    .matchedGeometryEffect(id: "courseImage\(pageIndex)", in: namespace)
            )
        }
    }
    
    private var courseInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            if homeTabViewModel.recommendedCoures.count == 3 {
                Text("\(homeTabViewModel.recommendedCoures[pageIndex].course.courseName)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)
                    .padding(.top, 47)
                    .offset(x: -20) // corner radius가 들어간 도형 안에 컨텐츠를 넣게 되면, 자동으로 왼쪽에 padding이 그만큼 들어가기 때문에, offset을 이용하여 왼쪽으로 이동시켜주는 것이 필요합니다.
                HStack {
                    Image(systemName: "mappin")
                    Text("\(homeTabViewModel.recommendedCoures[pageIndex].course.locationInfo.locality) \(homeTabViewModel.recommendedCoures[pageIndex].course.locationInfo.subLocality) • 내 위치에서 \(homeTabViewModel.recommendedCoures[pageIndex].distance/1000, specifier: "%.1f")km")
                }
                .font(.caption)
                .padding(.bottom, 16)
                .offset(x: -20)
                HStack {
                    Text("#\(homeTabViewModel.recommendedCoures[currentIndex].course.courseLength, specifier: "%.0f")km")
                        .font(.tag2)
                        .foregroundColor(Color.primaryColor)
                        .frame(width: 70, height: 23)
                        .background {
                            Capsule()
                                .stroke()
                                .foregroundColor(Color.primaryColor)
                        }
                    Text("#\(formatDuration(homeTabViewModel.recommendedCoures[currentIndex].course.courseDuration))")
                        .frame(width: 70, height: 23)
                        .font(.tag2)
                        .background {
                            Capsule()
                                .stroke()
                        }
                }
                .padding(.bottom, 36)
                .offset(x: -20)
            }
            
        }
        .background {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 318, height: 187)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .black.opacity(0), location: 0.00),
                            Gradient.Stop(color: .black.opacity(0.7), location: 0.33),
                            Gradient.Stop(color: .black.opacity(0.8), location: 1.00)
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
                .roundedCorners(45, corners: [.bottomLeft, .bottomRight])
        }
    }
    
}

#Preview {
    HomeTabView()
}
