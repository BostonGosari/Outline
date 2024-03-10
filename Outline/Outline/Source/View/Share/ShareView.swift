//
//  ShareView.swift
//  Outline
//
//  Created by hyebin on 11/21/23.
//

import CoreLocation
import SwiftUI

struct ShareView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ShareViewModel()
   
    let runningData: ShareModel
    
    var canvasData: CanvasData {
        return PathManager.getCanvasData(coordinates: runningData.userLocations, width: 200, height: 200)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    shareImageCombined
                    buttons
                }
                .padding(.top, 36)
            }
            .navigationTitle("공유")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
               ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        (Text(Image(systemName: "chevron.left")) + Text("뒤로"))
                            .foregroundStyle(Color.customPrimary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.onTapUploadImageButton(shareImageCombined: shareImageCombined)
                    } label: {
                        Text("공유")
                            .foregroundStyle(Color.customPrimary)
                    }
                }
           }
        }
        .confirmationDialog("이미지 선택", isPresented: $viewModel.isShowUploadImageSheet, actions: {
            Button {
                
            } label: {
                Text("사진 찍기")
            }
            Button {
                
            } label: {
                Text("이미지 선택")
            }
        }, message: {
            Text("이미지 선택")
        })
        .sheet(isPresented: $viewModel.permissionDenied) {
            PermissionSheet(permissionType: .photoLibrary)
        }
        .sheet(isPresented: $viewModel.isShowInstaAlert) {
            instaSheet
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: "이미지 저장이 완료되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
