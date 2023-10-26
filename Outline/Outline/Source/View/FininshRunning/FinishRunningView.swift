//
//  FinishRunningView.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import SwiftUI

struct FinishRunningView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = FinishRunningViewModel()
    var gradientColors: [Color] = [.blackColor, .blackColor, .blackColor, .blackColor, .black50Color, .blackColor.opacity(0)]
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: [])
    var runningRecord: FetchedResults<CoreRunningRecord>

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900Color
                    .ignoresSafeArea()
                VStack {
                    ZStack(alignment: .topLeading) {
                        FinishRunningMap(userLocations: $viewModel.userLocations)
                            .roundedCorners(45, corners: .bottomRight)
                            .shadow(color: .whiteColor, radius: 1.5)

                        VStack(spacing: 0) {
                            Text("\(viewModel.date)")
                                .font(.date)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 64)
                            
                            courseInfo
                        }
                            .background(
                                LinearGradient(
                                    colors: gradientColors,
                                    startPoint: .top, 
                                    endPoint: .bottom
                                )
                            )
                    }
                    .ignoresSafeArea()
                    
                    runningData
                        .padding(.top, 32)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                    
                    CompleteButton(text: "자랑하기", isActive: true) {
                        viewModel.saveShareData()
                    }
                    .padding(.bottom, 16)
                    
                    Button(action: {
                        homeTabViewModel.running = false
                    }, label: {
                        Text("나중에 자랑하기")
                            .underline(pattern: .solid)
                            .foregroundStyle(Color.gray300Color)
                    })
                    .padding(.bottom, 8)
                }
            }
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: "기록이 저장되었어요.")
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 712)
                    .transition(.move(edge: .top))
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToShareMainView) {
            ShareMainView(homeTabViewModel: homeTabViewModel, runningData: viewModel.shareData)
                .navigationBarBackButtonHidden()
        }
        .onAppear {
            viewModel.isShowPopup = true
            viewModel.readData(runningRecord: runningRecord)
        }
    }
}

extension FinishRunningView {
    private var courseInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(viewModel.courseName)")
                .font(.headline)
            
            HStack {
                Image(systemName: "calendar")
                Text("\(viewModel.startTime)-\(viewModel.endTime)")
            }
            .font(.subBody)
            .foregroundStyle(Color.gray200Color)
            
            HStack {
                Image(systemName: "mappin")
                    .foregroundStyle(Color.gray400Color)
                
                Text("\(viewModel.courseRegion)")
                    .foregroundStyle(Color.gray200Color)
            }
            .font(.subBody)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 24)
        .padding(.leading, 16)
    }
    
    private var runningData: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        
        return LazyVGrid(columns: columns) {
            ForEach(viewModel.runningData, id: \.self) { runningData in
                VStack(alignment: .center) {
                    Text("\(runningData.data)")
                        .font(.title2)
                    Text(runningData.text)
                        .font(.subBody)
                }
                .padding(.bottom, 16)
            }
        }
    }
}
