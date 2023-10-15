//
//  TabModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
}

var tabItems = [
    TabItem(text: "자유러닝", icon: "map.fill", tab: .freeRunning),
    TabItem(text: "GPS 아트러닝", icon: "paintpalette.fill", tab: .GPSArtRunning),
    TabItem(text: "나의기록", icon: "doc.text.fill", tab: .myRecord)
]

enum Tab: String {
    case freeRunning
    case GPSArtRunning
    case myRecord
}
