//
//  ViewExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

extension View {
        
    /// 원하는 코너에 라운딩을 적용하는  `View Extension`
    /// - Parameters:
    ///   - radius: 라운딩의 정도
    ///   - corners: 원하는 코너 [.topLeft, .topRight] 의 **배열 형식**으로 입력해주세요
    func roundedCorners(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornersShape(radius: radius, corners: corners))
    }
    
    /// ```swift
    /// @State private var scrollViewOffset: CGFloat = 0
    ///
    /// .onScrollViewOffsetChanged { value
    ///    in scrollViewOffset = value
    /// }
    /// ```
    /// scrollViewOffset 변수 선언을 해준뒤 함수를 사용하여 scrollViewOffset 의 변화를 추적
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
    
    func asImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        let image = controller.view.asImage(size: size)
        return image
    }
}

extension UIView {
    func asImage(size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}
