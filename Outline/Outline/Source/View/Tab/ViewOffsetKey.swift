//
//  ex.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
     static var defaultValue: CGFloat = 0
     
     static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
         value = max(value, nextValue())
     }
}
