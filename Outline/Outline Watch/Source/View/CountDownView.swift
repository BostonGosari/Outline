//
//  CountDownView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/3/23.
//

import SwiftUI

struct CountDownView: View {
    @StateObject var workoutManager = WatchWorkoutManager.shared
    @State private var countdownSeconds = 3

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .ignoresSafeArea()
            VStack {
                if countdownSeconds > 0 {
                    Image("Count\(countdownSeconds)")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                countdownSeconds -= 1
                                if countdownSeconds == 0 {
                                    timer.invalidate()
                                    workoutManager.selectedWorkout = .running
                                }
                            }
                        }
                } else {
                    WatchTabView() // 카운트다운이 끝나면 WatchTabView로 이동
                }
            }
        }
    }
}

#Preview {
    CountDownView()
}
