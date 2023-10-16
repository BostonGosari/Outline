//
//  ScrollWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct ScrollWatchView: View {
    var body: some View {
        NavigationStack {
            List {
                Button{
                    
                } label: {
                    Text("Button")
                }
                Text("hello")
                Text("hello")
                Text("hello")
                Text("hello")
                Text("hello")
            }
            .navigationTitle("러닝")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ScrollWatchView()
}
