//
//  RunningView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.

import SwiftUI

struct RunningView: View {
    
    @ObservedObject var vm: HomeTabViewModel
    @State var selection = 0
    
    init(vm: HomeTabViewModel) {
        self.vm = vm
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.primary
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("Gray900").ignoresSafeArea()
            TabView(selection: $selection) {
                RunningMapView(vm: vm, selection: $selection)
                    .tag(0)
                WorkoutDataView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
