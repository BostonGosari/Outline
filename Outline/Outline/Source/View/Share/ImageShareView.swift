//
//  ImageShareView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import SwiftUI

struct ImageShareView: View {
    
    @ObservedObject var viewModel: ShareViewModel
    
    @State private var isPhotoMode = false
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            Color.gray900Color
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    Button {
                        showingSheet = true
                    } label: {
                        Rectangle()
                    }
                }
                .aspectRatio(1080/1920, contentMode: .fit)
                .padding(EdgeInsets(top: 20, leading: 49, bottom: 16, trailing: 49))
                
                pageIndicator
                
                selectModeView
            }
        }
        .confirmationDialog("이미지 선택", isPresented: $showingSheet) {
            Button("사진 찍기") {
                
            }
            Button("이미지 선택") {
                
            }
            
            Button("Cancel", role: .cancel) {}
        }
        
    }
}

extension ImageShareView {
    private var pageIndicator: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.whiteColor)
                .frame(width: 25, height: 3)
                .padding(.trailing, 5)
            
            Rectangle()
                .fill(Color.primaryColor)
                .frame(width: 25, height: 3)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 168)
        .padding(.bottom, 32)
    }
    
    private var selectModeView: some View {
        HStack(spacing: 0) {
            Button {
                isPhotoMode = false
            } label: {
                Circle()
                    .fill(.black)
                    .stroke(isPhotoMode ?  Color.gray200Color : Color.primaryColor, lineWidth: 5)
            }
            .padding(.horizontal, 12)
            
            Button {
                isPhotoMode = true
            } label: {
                Circle()
                    .fill(.white)
                    .stroke(isPhotoMode ? Color.primaryColor : Color.gray200Color, lineWidth: 5)
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 143)
        .padding(.bottom, 110)
    }
}
