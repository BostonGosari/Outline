//
//  CoreMotionView.swift
//  Outline
//
//  Created by hyunjun on 10/17/23.
//

import SwiftUI

struct CoreMotionView: View {
    
    @StateObject var viewModel = CoreMotionViewModel()
    
    let weight: Double = 60
    
    var body: some View {
        NavigationStack {
            List {
                Section("전송 데이터") {
                    Text("Steps: \(viewModel.steps)")
                    Text("Distance: \(viewModel.distance) meters")
                }
                
                Section("가져올 수 있는 러닝 데이터") {
                    Text("Start Date : \(viewModel.start?.description ?? "시작 전")")
                    Text("End Date : \(viewModel.end?.description ?? "종료 전")")
                    Text("Current pace: \(viewModel.pace) seconds per meter")
                    Text("Average pace: \(viewModel.avgPace) seconds per meter")
                    Text("Current cadence: \(viewModel.cadence) steps per second")
                }
                
                Section("계산 러닝 데이터") {
                    Text("현재 케이던스: \(viewModel.cadence * viewModel.pace) SPM")
                    if viewModel.distance != 0 {
                        Text("평균 케이던스: \(viewModel.steps / viewModel.distance) SPM")
                    } else {
                        Text("평균 케이던스: \(viewModel.cadence * viewModel.pace) SPM")
                    }
                    Text("현재 페이스 : \(viewModel.pace / 60 * 1000) minute")
                    Text("평균 페이스 : \(viewModel.avgPace / 60 * 1000) minute")
                    Text("칼로리 : 약 \(viewModel.kilocalorie) kcal")
                }
                .onChange(of: viewModel.distance) { distance in
                    viewModel.kilocalorie = weight * distance / 1000 * 1.036
                }
                
                Section {
                    Button(viewModel.isTracking ? "Stop Tracking" : "Start Tracking") {
                        viewModel.toggleTracking()
                    }
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .listRowBackground(viewModel.isTracking ? Color.green : Color.orange)
                    .animation(.easeInOut, value: viewModel.isTracking)
                    .foregroundStyle(.white)
                }
            }
            .navigationTitle("러닝 데이터 측정")
        }
    }
}

#Preview {
    CoreMotionView()
}
