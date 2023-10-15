//
//  InputUserInfoView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//
import os
import SwiftUI
import HealthKit
import HealthKitUI

struct InputUserInfoView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var triggerAuthorization = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("사용자 정보 입력")
            }
            .onAppear {
                workoutManager.requestAuthorization()
            }
        }
    }
}

#Preview {
    InputUserInfoView()
}
