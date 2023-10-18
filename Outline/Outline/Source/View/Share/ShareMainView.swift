//
//  ShareMainView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct ShareMainView: View {
    
    @StateObject private var viewModel = ShareViewModel()
    @State private var shareImage = UIImage()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900Color
                
                TabView {
                    CustomShareView(viewModel: viewModel)
                    ImageShareView()
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 0) {
                    Button {
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
                        viewModel.shareToInstagram()
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
                    Text("< 홈으로")
                        .foregroundStyle(Color.primaryColor)
                }
            }
    
        }
    }
}

#Preview {
    ShareMainView()
}
