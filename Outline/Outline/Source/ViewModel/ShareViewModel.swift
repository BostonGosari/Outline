//
//  ShareViewModel.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import Photos
import SwiftUI
import PhotosUI

class ShareViewModel: ObservableObject {
    @Published var permissionDenied = false
    @Published var isShowCameraAuthorization = false
    @Published var isShowCamera = false
    @Published var isShowPhotouthorization = false
    @Published var isShowPhoto = false
    @Published var isShowInstaAlert = false
    @Published var isShowUploadImageSheet = false
    @Published var size: CGSize = .zero
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 0
    @Published var offset: CGSize = .zero
    @Published var lastStoredOffset: CGSize = .zero
    @Published var angle: Angle = .degrees(0)
    @Published var lastAngle: Angle = .degrees(0)
    @Published var renderedImage: UIImage?
    @Published var uploadedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem?
    @Published var isSizeFixed = false
    @Published var currentCourseName = ""
    
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowPopup = false
                }
            }
        }
    }
    
    func initUserPath() {
        scale = 1
        lastScale = 0
        offset = .zero
        lastStoredOffset = .zero
        angle = .degrees(0)
        lastAngle = .degrees(0)
    }
    
    func shareToInstagram(image: UIImage) {
        guard let url = URL(string: "instagram-stories://share?source_application=Outline"),
              let imageData = image.pngData() else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            let pasteboardItems: [String: Any] = ["com.instagram.sharedSticker.backgroundImage": imageData]
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
    
    @MainActor
    func onTapSaveImageButton(shareTabViews: some View, isSave: Bool = true) {
        renderShareView(shareTabViews, isSave)
        if let img = renderedImage {
            DispatchQueue.main.async {
                self.saveImage(image: img)
            }
        }
    }
    
    @MainActor
    func onTapUploadImageButton(shareTabViews: some View, isSave: Bool = false) {
        renderShareView(shareTabViews, isSave)
        if let img = renderedImage {
            shareToInstagram(image: img)
        }
    }
    
    @MainActor
    func renderShareView(_ shareImageCombined: some View, _ isSave: Bool = true) {
        renderedImage = shareImageCombined
            .frame(width: size.width, height: size.height)
            .background(isSave ? .black : .clear)
            .render(scale: 3)
    }
    
    @MainActor
    func onAppearSharedImageCombined(size: CGSize) {
        self.size = size
    }
}

extension ShareViewModel {
    @MainActor
    func onTapCameraButton() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            isShowCamera = true
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { accessGranted in
                DispatchQueue.main.async {
                    if accessGranted {
                        print("카메라 권한이 허용되었습니다. ")
                    } else {
                        print("카메라 권한이 거부되었습니더.")
                    }
                }
            }
        } else {
            print("카메라 권한이 거부된 상태입니다.")
            isShowCameraAuthorization = true
        }
    }
    
    @MainActor
    func onTapSelectImageButton() {
        isShowPhoto = true
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
