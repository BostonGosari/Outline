//
//  FontExtension.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

extension Font {
    static let customHeadline = Font.custom("SF Pro Display", size: 40, relativeTo: .largeTitle)
    static let customSubHeadline = Font.custom("SF Pro Display", size: 32, relativeTo: .title)
    static let customLargeTitle = Font.custom("SF Pro Display", size: 24, relativeTo: .headline)
    static let customTitle = Font.custom("SF Pro Display", size: 21, relativeTo: .headline)
    static let customSubTitle = Font.custom("SF Pro Display", size: 14, relativeTo: .subheadline)
    static let customButton = Font.custom("SF Pro Display", size: 13, relativeTo: .body)
    static let customBody = Font.custom("SF Pro Display", size: 13, relativeTo: .body)
    static let customCaption = Font.custom("SF Pro Display", size: 11, relativeTo: .caption)
    static let customCaption2 = Font.custom("SF Pro Display", size: 10, relativeTo: .caption2)
    static let customCaption3 = Font.custom("SF Pro Display", size: 8, relativeTo: .caption2)
    static let customSystemImage = Font.custom("SF Pro Display", size: 20, relativeTo: .title)
}
