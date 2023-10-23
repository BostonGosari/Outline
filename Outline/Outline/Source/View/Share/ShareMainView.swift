//
//  ShareMainView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import CoreLocation
import SwiftUI

struct ShareMainView: View {
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    @StateObject private var viewModel = ShareViewModel()
    let runningData: ShareModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900Color
                    .ignoresSafeArea()
                
                TabView(selection: $viewModel.currentPage) {
                    CustomShareView(viewModel: viewModel)
                        .tag(0)
                    ImageShareView(viewModel: viewModel)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 0) {
                    Button {
                        viewModel.tapSaveButton = true
                        viewModel.saveImage()
                    }  label: {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 19)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.whiteColor)
                            }
                    }
                    .padding(.leading, 16)
                    
                    CompleteButton(text: "공유하기") {
                        viewModel.tapShareButton = true
                        if viewModel.shareToInstagram() {
                            homeTabViewModel.running = false
                        }
                    }
                    .padding(.leading, -8)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 42)
            }
            .ignoresSafeArea()
            .modifier(NavigationModifier(homeTabViewModel: homeTabViewModel))
            .onAppear {
                viewModel.runningData = runningData
                print(runningData)
            }
            .overlay {
                if viewModel.isShowPopup {
                    RunningPopup(text: "이미지 저장이 완료되었어요.")
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 74)
                }
            }
        }
    }
}

struct NavigationModifier: ViewModifier {
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("공유")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        homeTabViewModel.running = false
                    } label: {
                        (Text(Image(systemName: "chevron.left")) + Text("홈으로"))
                            .foregroundStyle(Color.primaryColor)
                    }
                }
            }
    }
}

//#Preview {
//    ShareMainView(runningData: ShareModel(
//        courseName: "고래런",
//        runningDate: "2023.10.19",
//        runningRegion: "경상북도 포항시 지곡동",
//        distance: "11km",
//        cal: "127kcal",
//        pace: "5’55\"",
//        bpm: "132 BPM",
//        time: "2hourse",
//        userLocations: [
//            CLLocationCoordinate2D(latitude: 36.0141253, longitude: 129.3471313),
//            CLLocationCoordinate2D(latitude: 36.0154791, longitude: 129.3444276),
//            CLLocationCoordinate2D(latitude: 36.0102547, longitude: 129.3394495),
//            CLLocationCoordinate2D(latitude: 36.0097687, longitude: 129.3391061),
//            CLLocationCoordinate2D(latitude: 36.008276, longitude: 129.3358231)
//        ]
//    ))
//}
