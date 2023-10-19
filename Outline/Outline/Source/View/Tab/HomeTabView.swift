//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct HomeTabView: View {
    
    @State var selectedTab: Tab = .GPSArtRunning
    
    @Namespace var namespace
    @State var currentIndex = 0
    @State var isShow = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Gray900").ignoresSafeArea()
                ZStack(alignment: .bottom) {
                    Group {
                        switch selectedTab {
                        case .freeRunning:
                            FreeRunningHomeView()
                        case .GPSArtRunning:
                            GPSArtHomeView(isShow: $isShow, namespace: namespace)
                        case .myRecord:
                            Text("나의기록 뷰")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    TabBar(selectedTab: $selectedTab)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .opacity(isShow ? 0 : 1)
                        .ignoresSafeArea()
                }
            }
        }
        .tint(.primaryColor)
    }
}

#Preview {
    HomeTabView()
}
