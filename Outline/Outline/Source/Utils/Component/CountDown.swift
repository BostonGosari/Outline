//
//  CountDown.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/20/23.
//

import SwiftUI

struct CountDown: View {
    @StateObject private var runningManager = RunningStartManager.shared
    @StateObject private var watchConnectivityManager = WatchConnectivityManager.shared
    @State var count = 3
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            Group {
                switch count {
                case 3:
                    Image("Number3")
                        .resizable()
                case 2:
                    Image("Number2")
                        .resizable()
                case 1:
                    Image("Number1")
                        .resizable()
                default:
                    Text("error")
                }
            }
            .scaledToFit()
            .frame(height: 180)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                count = 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                count = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                runningManager.start = false
                if WatchConnectivityManager.shared.session.isWatchAppInstalled {
                    if let course = runningManager.startCourse {
                        watchConnectivityManager.sendGPSArtCourse(course)
                    }
                    WorkoutManager.shared.startRunningOnWatch()
                    runningManager.mirroringRunning = true
                } else {
                    runningManager.running = true
                }
            }
        }
    }
}
