//
//  RunningView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.

import SwiftUI

struct RunningView: View {
    
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    
    @StateObject var runningViewModel: RunningViewModel
    @StateObject var digitalTimerViewModel = DigitalTimerViewModel()
    @State var selection = 0
    
    init(homeTabViewModel: HomeTabViewModel) {
        self.homeTabViewModel = homeTabViewModel
        self._runningViewModel = StateObject(wrappedValue: RunningViewModel(homeTabViewModel: homeTabViewModel))

        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.primary
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("Gray900").ignoresSafeArea()
                TabView(selection: $selection) {
                    RunningMapView(runningViewModel: runningViewModel, digitalTimerViewModel: digitalTimerViewModel, homeTabViewModel: homeTabViewModel, selection: $selection)
                        .tag(0)
                    WorkoutDataView(runningViewModel: runningViewModel, digitalTimerViewModel: digitalTimerViewModel)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if homeTabViewModel.running == true {
                        runningViewModel.startRunning()
                        digitalTimerViewModel.startTimer()
                    }
                }
            }
        }
    }
}

#Preview {
    RunningView(homeTabViewModel: HomeTabViewModel())
}
