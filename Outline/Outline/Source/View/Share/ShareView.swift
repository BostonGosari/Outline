//
//  ShareView.swift
//  Outline
//
//  Created by hyebin on 11/21/23.
//

import CoreLocation
import SwiftUI
import PhotosUI

struct ShareView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ShareViewModel()
    @FocusState var isFocused: Bool
    
    @State var currentShareView = 0
   
    let runningData: ShareModel
    let indexWidth: CGFloat = 24
    let indexHeight: CGFloat = 4
    
    var canvasData: CanvasData {
        return PathManager.getCanvasData(coordinates: runningData.userLocations, width: 150, height: 150)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray900
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 0) {
                        shareTabViews
                        
                        tabButtons
                        
                        Spacer(minLength: 32)
                        
                        buttons
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .scrollDisabled(true)
            }
            .navigationTitle("공유 이미지 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
               ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("닫기")
                            .foregroundStyle(Color.customPrimary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selecteRenderView(isSave: false)
                    } label: {
                        Text("공유")
                            .foregroundStyle(Color.customPrimary)
                    }
                }
           }
        }
        .photosPicker(isPresented: $viewModel.isShowPhoto, selection: $viewModel.selectedItem, matching: .images)
        .confirmationDialog("이미지 선택", isPresented: $viewModel.isShowUploadImageSheet, actions: {
            Button {
                viewModel.onTapCameraButton()
            } label: {
                Text("사진 찍기")
            }
            Button {
                viewModel.onTapSelectImageButton()
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
        .fullScreenCover(isPresented: $viewModel.isShowCamera) {
            AccessCameraView(selectedImage: $viewModel.uploadedImage)
                .ignoresSafeArea()
        }
        .onAppear {
            viewModel.currentCourseName = runningData.courseName
        }
        .onChange(of: viewModel.selectedItem) {
            Task {
                if let data = try? await viewModel.selectedItem?.loadTransferable(type: Data.self) {
                    viewModel.uploadedImage = UIImage(data: data)
                } else {
                    print("data error")
                }
            }
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: "이미지 저장이 완료되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    var shareTabViews: some View {
        TabView(selection: $currentShareView) {
            firstShareView
                .tag(0)
            
            secondShareView
                .tag(1)
            
            thirdShareView
                .tag(2)
            
            fourthShareView
                .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: UIScreen.main.bounds.height * 0.7)
        .gesture(DragGesture().onChanged { _ in })
    }
}

extension ShareView {
    func selecteRenderView(isSave: Bool) {
        switch currentShareView {
        case 0:
            if isSave {
                viewModel.onTapSaveImageButton(shareTabViews: firstShareView)
            } else {
                viewModel.onTapUploadImageButton(shareTabViews: firstShareView)
            }
        case 1:
            ShareMapView(userLocations: runningData.userLocations)
                .captureMapSnapshot(size: viewModel.size) { img in
                    if isSave {
                        viewModel.onTapSaveImageButton(shareTabViews: renderSecondShareView(img))
                    } else {
                        viewModel.onTapUploadImageButton(shareTabViews: renderSecondShareView(img))
                    }
                }
        case 2:
            if isSave {
                viewModel.onTapSaveImageButton(shareTabViews: renderThirdShareView())
            } else {
                viewModel.onTapUploadImageButton(shareTabViews: renderThirdShareView())
            }
        case 3:
            ShareMapView(userLocations: runningData.userLocations)
                .captureMapSnapshot(
                    size: CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                ) { img in
                    if isSave {
                        viewModel.onTapSaveImageButton(shareTabViews: renderFourthShareView(img))
                    } else {
                        viewModel.onTapUploadImageButton(shareTabViews: renderFourthShareView(img))
                    }
                }
        default:
            return
        }
    }
}
