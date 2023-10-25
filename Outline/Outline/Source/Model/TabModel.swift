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
    TabItem(text: "자유러닝", icon: "Tab1", tab: .freeRunning),
    TabItem(text: "GPS 아트러닝", icon: "Tab2", tab: .GPSArtRunning),
    TabItem(text: "나의기록", icon: "Tab3", tab: .myRecord)
]

enum Tab: String {
    case freeRunning
    case GPSArtRunning
    case myRecord
}
