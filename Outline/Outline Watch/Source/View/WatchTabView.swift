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
            Text("Control View")
            MapWatchView()
            Text("Running View")
        }
    }
}

#Preview {
    WatchTabView()
}
