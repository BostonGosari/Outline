//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct TabView: View {
    
    @State var selectedTab: Tab = .GPSArtRunning
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Gray900").ignoresSafeArea()
                ZStack(alignment: .bottom) {
                    Group {
                        switch selectedTab {
                        case .freeRunning:
                            Text("자유러닝 뷰")
                        case .GPSArtRunning:
                            Text("GPS 아트러닝 뷰")
                        case .myRecord:
                            Text("나의기록 뷰")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    TabBar(selectedTab: $selectedTab)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
    }
}

#Preview {
    TabView()
}
