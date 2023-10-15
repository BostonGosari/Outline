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
}
