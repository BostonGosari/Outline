//
//  FinishRunningView.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import SwiftUI

struct FinishRunningView: View {
    @StateObject var viewModel = FinishRunningViewModel()
    private var gradientColors: [Color] = [.blackColor, .blackColor, .blackColor, .blackColor, .black50Color, .blackColor.opacity(0)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900Color
                    .ignoresSafeArea()
                VStack {
                    ZStack(alignment: .topLeading) {
                        FinishRunningMap(userLocations: viewModel.userLocations)
                            .roundedCorners(45, corners: .bottomLeft)
                            .shadow(color: .whiteColor, radius: 1.5)

                        courseInfo
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
                    
                    CompleteButton(text: "자랑하기") {
                        // MoveTo shareView
                    }
                    .padding(.bottom, 16)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("나중에 자랑하기")
                            .underline(pattern: .solid)
                            .foregroundStyle(Color.gray300Color)
                    })
                    .padding(.bottom, 8)
                }
            }
            .navigationTitle("\(viewModel.date)")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: "기록이 저장되었어요.")
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            viewModel.isShowPopup = true
            viewModel.readRunningData()
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
        .padding(.top, 100)
        .padding(.leading, 16)
    }
    
    private var runningData: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        
        return LazyVGrid(columns: columns) {
            ForEach((0...5), id: \.self) { _ in
                VStack(alignment: .center) {
                    Text("\(viewModel.time)")
                        .font(.title2)
                    Text("시간")
                        .font(.subBody)
                }
                .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
    FinishRunningView()
}
