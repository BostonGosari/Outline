//
//  TabView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct TabView: View {
    
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
                            Text("자유러닝 뷰")
                        case .GPSArtRunning:
                            GPSArtHomeView(namespace: namespace, isShow: $isShow, currentIndex: $currentIndex)
                        case .myRecord:
                            Text("나의기록 뷰")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    TabBar(selectedTab: $selectedTab)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    
                    if isShow {
                        Color.gray900Color.ignoresSafeArea()
                        CardDetailView(namespace: namespace, isShow: $isShow, currentIndex: currentIndex)
                            .zIndex(1)
                            .transition(
                                .asymmetric(
                                    insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                                    removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                                )
                            )
                            .ignoresSafeArea()
                    }
                }
            }
        }
    }
}

#Preview {
    TabView()
}
