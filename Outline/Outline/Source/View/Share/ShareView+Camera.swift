//
//  ShareView+Camera.swift
//  Outline
//
//  Created by Seungui Moon on 3/10/24.
//

import SwiftUI

class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage
    @Binding var isActive: Bool
    
    init(image: Binding<UIImage>, isActive: Binding<Bool>) {
        _image = image
        _isActive = isActive
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiImage
            isActive = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isActive = false
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    //coordinator
    @Binding var image: UIImage
    @Binding var isActive: Bool
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //do nothing
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, isActive: $isActive)
    }
}
