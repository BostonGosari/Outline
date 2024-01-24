//
//  ViewExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

extension View {
    func roundedCorners(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornersShape(radius: radius, corners: corners))
    }
    
    func onScrollViewOffsetChanged(action: @escaping (_ offset: CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                action(value)
            }
    }
    
    func onScrollViewXOffsetChanged(action: @escaping (_ offset: CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Text("")
                        .coordinateSpace(name: "scroll")
                        .preference(key: ScrollViewXOffsetPreferenceKey.self, value: geo.frame(in: .named("scroll")).minX)
                }
            )
            .onPreferenceChange(ScrollViewXOffsetPreferenceKey.self) { value in
                action(value)
            }
    }
    
    func asImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        let image = controller.view.asImage(size: size)
        if let pngData = image.pngData(), let pngImage = UIImage(data: pngData) {
            return pngImage
        }
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    func asImage(size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = true
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}
