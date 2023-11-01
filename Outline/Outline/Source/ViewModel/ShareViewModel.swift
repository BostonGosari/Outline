//
//  ShareViewModel.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import Photos
import SwiftUI

class ShareViewModel: ObservableObject {
    
    @Published var runningData = ShareModel()
    @Published var currentPage = 0
    @Published var showCamera = false
    @Published var showImagePicker = false
    @Published var permissionDenied = false
    @Published var customImage: UIImage?
    @Published var posterImage: UIImage?
    
    @Published var tapSaveButton = false
    @Published var tapShareButton = false
    
    @Published var isShowInstaAlert = false
    
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowPopup = false
                }
            }
        }
    }
    
    private var shareImage: UIImage?
    
    var alertTitle = ""
    var alertMessage = ""
    
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.showCamera = true
            } else {
                self.alertTitle = "카메라 권한 허용"
                self.alertMessage = "권한을 허용하면 사진을 찍어 업로드할 수 있어요."
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
                self.alertTitle = "사진 권한 허용"
                self.alertMessage = "권한을 허용하면 사진을 함께 업로드할 수 있어요."
                self.permissionDenied = true
            case .restricted, .notDetermined:
                self.alertTitle = "사진 권한 허용"
                self.alertMessage = "권한을 허용하면 사진을 함께 업로드할 수 있어요."
                self.permissionDenied = true
            default:
                break
            }
        }
    }
    
    func shareToInstagram() -> Bool {
        guard let url = URL(string: "instagram-stories://share?source_application=helia"),
              let image = shareImage,
              let imageData = image.pngData() else { return false }

        if UIApplication.shared.canOpenURL(url) {
            let pasteboardItems: [String: Any] = ["com.instagram.sharedSticker.stickerImage": imageData]
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]

            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            UIApplication.shared.open(url)
            return true
        } else {
            print("인스타그램이 설치되어 있지 않습니다.")
            isShowInstaAlert = true
            
            return false
        }
    }
    
    func saveImage() {
        if currentPage == 0 {
            shareImage = customImage
        } else {
            shareImage = posterImage
        }
        
        if let image = shareImage {
            print(currentPage)
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: image)
            isShowPopup = true
        }
    }
    
    func renderLayerImage() {
    }
}

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error)
        } else {
            print("Save finished!")
        }
    }
}
