//
//  RunningView.swift
//  Outline
//
//  Created by 김하은 on 10/17/23.

import SwiftUI

struct RunningView: View {
    @ObservedObject var homeTabViewModel: HomeTabViewModel
    
    @StateObject var runningManager = RunningManager.shared
    @StateObject var runningViewModel: RunningViewModel
    @StateObject var digitalTimerViewModel = DigitalTimerViewModel()
    
    @State var checkRunning = true
    @State var selection = 0
    
    init(homeTabViewModel: HomeTabViewModel) {
        self.homeTabViewModel = homeTabViewModel
        self._runningViewModel = StateObject(wrappedValue: RunningViewModel(homeTabViewModel: homeTabViewModel))
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.customBlack
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.white
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("Gray900").ignoresSafeArea()
                TabView(selection: $selection) {
                    RunningMapView(runningViewModel: runningViewModel, digitalTimerViewModel: digitalTimerViewModel, selection: $selection)
                        .tag(0)
                    WorkoutDataView(runningViewModel: runningViewModel, digitalTimerViewModel: digitalTimerViewModel)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if runningManager.running == true {
                        runningViewModel.startRunning()
                        digitalTimerViewModel.startTimer()
                    }
                }
                
                    ZStack {
                        //TODO: Distance Check
//                        if !locationManager.checkDistance && checkRunning {
//                            Color.black.opacity(0.5)
//                        }
                        VStack(spacing: 10) {
                            Text("자유코스로 변경할까요?")
                                .font(.title2)
                            Text("앗! 현재 루트와 멀리 떨어져 있어요.")
                                .font(.subBody)
                                .foregroundColor(.gray300)
                            Image("AnotherLocation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                            Button {
                                runningManager.startFreeRun()
                                checkRunning = false
                            } label: {
                                Text("자유코스로 변경하기")
                                    .font(.button)
                                    .foregroundStyle(Color.customBlack)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .foregroundStyle(Color.customPrimary)
                                    }
                            }
                            .padding()
                        }
                        .frame(height: UIScreen.main.bounds.height / 2)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.customPrimary, lineWidth: 2)
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .foregroundStyle(Color.gray900)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        //TODO: Check Distace
//                        .offset(y: !locationManager.checkDistance && checkRunning ? 0 : UIScreen.main.bounds.height / 2 + 2)
//                        .animation(.easeInOut, value: locationManager.checkDistance)
                    .ignoresSafeArea()
                }
            }
        }
    }
}

#Preview {
    RunningView(homeTabViewModel: HomeTabViewModel())
}
