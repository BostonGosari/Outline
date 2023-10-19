//
//  ShareMainView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct ShareMainView: View {
    
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
                    }
                    .padding(.leading, -8)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 42)
            }
            .ignoresSafeArea()
            .navigationTitle("공유")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    (Text(Image(systemName: "chevron.left")) + Text("홈으로"))
                        .foregroundStyle(Color.primaryColor)
                }
            }
        }
    }
}

#Preview {
    ShareMainView(runningData: ShareModel(
        courseName: "고래런",
        runningDate: "2023.10.19",
        runningregion: "경상북도 포항시 지곡동",
        distance: "11km",
        cal: "127kcal",
        pace: "5’55\"",
        bpm: "132 BPM",
        time: "2hourse"
    ))
}
