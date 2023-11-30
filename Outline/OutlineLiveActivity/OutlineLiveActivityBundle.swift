//
//  OutlineLiveActivityBundle.swift
//  OutlineLiveActivity
//
//  Created by 김하은 on 11/29/23.
//

import WidgetKit
import SwiftUI

@main
struct OutlineLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.2, *) {
            OutlineLiveActivity()
        }
    }
}
