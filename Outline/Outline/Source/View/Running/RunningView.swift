//
//  RunningView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.

import SwiftUI

struct RunningView: View {
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.first
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("Gray900").ignoresSafeArea()
            TabView {
                RunningMapView()
                WorkoutDataView()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    RunningView()
}
