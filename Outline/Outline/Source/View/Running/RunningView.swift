//
//  RunningView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.

import SwiftUI

struct RunningView: View {
    
    @State var selection = 0
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.primary
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("Gray900").ignoresSafeArea()
            TabView(selection: $selection) {
                RunningMapView(selection: $selection)
                    .tag(0)
                WorkoutDataView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    RunningView()
}
