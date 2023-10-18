//
//  ShareViewModel.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import Photos
import SwiftUI

class ShareViewModel: ObservableObject {
    
    @Published var showCamera = false
    @Published var showImagePicker = false
    @Published var permissionDenied = false
    
    var alertTitle = ""
    var alertMessage = ""
    
    // image Render
    
    // instagram share
    
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.showCamera = true
            } else {
                self.alertTitle = "카메라에 접근할 수 없습니다."
                self.alertMessage = "설정에서 카메라 권한을 허용해주세요."
                self.permissionDenied = true
            }
        }
    }
    
    func checkAlbumPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.showImagePicker = true
            case .denied:
                self.alertTitle = "카메라에 접근할 수 없습니다."
                self.alertMessage = "설정에서 카메라 권한을 허용해주세요."
                self.permissionDenied = true
            case .restricted, .notDetermined:
                self.alertTitle = "사진에 접근할 수 없습니다."
                self.alertMessage = "설정에서 사진 권한을 허용해주세요."
                self.permissionDenied = true
            default:
                break
            }
        }
    }
    
    func shareToInstagram() {
        
    }
    
    func saveImage() {
        
    }
    
    private func imageRender() {
        
    }
}
