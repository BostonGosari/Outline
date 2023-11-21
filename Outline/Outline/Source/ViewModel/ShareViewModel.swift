//
//  ShareViewModel.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import Photos
import SwiftUI

class ShareViewModel: ObservableObject {
    @Published var permissionDenied = false
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
    
    func shareToInstagram(image: UIImage) {
        guard let url = URL(string: "instagram-stories://share?source_application=Outline"),
              let imageData = image.pngData() else { return }

        if UIApplication.shared.canOpenURL(url) {
            let pasteboardItems: [String: Any] = ["com.instagram.sharedSticker.stickerImage": imageData]
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]

            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            UIApplication.shared.open(url)
        } else {
            print("인스타그램이 설치되어 있지 않습니다.")
            isShowInstaAlert = true
        }
    }
    
    func saveImage(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: image)
                self.isShowPopup = true
            case .denied:
                self.permissionDenied = true
            case .restricted, .notDetermined:
                self.permissionDenied = true
            default:
                break
            }
        }
    }
    
    func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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
