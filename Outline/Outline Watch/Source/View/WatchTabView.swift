//
//  WatchTabView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct WatchTabView: View {
    var body: some View {
        TabView {
            Text("Control View") // 뷰를 넣어주세요
            MapWatchView()
            Text("Running View") // 뷰를 넣어주세요
        }
    }
}

#Preview {
    WatchTabView()
}
