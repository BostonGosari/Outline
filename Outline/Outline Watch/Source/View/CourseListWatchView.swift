//
//  CourseListWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI
import HealthKit

struct CourseListWatchView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.running]
    @State private var countdownSeconds = 3 
    @State private var detailViewNavigate = false
    @Binding var navigate: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: -5) {
                    Button {
                        navigate.toggle()
                    } label: {
                           HStack {
                               Image(systemName: "play.circle")
                               Text("자유러닝")
                                   .foregroundColor(.black)
                           }
                           .frame(height: 48)
                           .frame(maxWidth: .infinity)
                           .background(
                               RoundedRectangle(cornerRadius: 12, style: .continuous)
                                   .foregroundColor(.green)
                           )
                       }
                    .buttonStyle(.plain)
                    .navigationDestination(isPresented: $navigate, destination: {
                        countdownView()
                            .onAppear {
                                countdownSeconds = 3
                            }
                    })

                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            .opacity(phase.isIdentity ? 1 : 0.8)
                    }
                    .padding(.bottom, 8)
                    ForEach(0..<5) {_ in
                        Button {
                            print("button clicked")
                        } label: {
                            VStack {
                                Text("시티런")
                                    .padding(.leading, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay(alignment: .trailing) {
                                        Button {
                                            detailViewNavigate = true
                                            print("ellipsis clicked")
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .font(.system(size: 24))
                                                .frame(width: 48, height: 48)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.trailing, -4)
                                    }
                                Circle()
                                    .stroke(lineWidth: 4)
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 8)
                            .frame(height: 136)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .buttonStyle(.plain)
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                .opacity(phase.isIdentity ? 1 : 0.8)
                        }
                    }
                }
            }
            .navigationTitle("러닝")
            .navigationDestination(isPresented: $detailViewNavigate) {
                Text("DetailView")
            }
            .onAppear {
                workoutManager.requestAuthorization()
            }
        }
    }
    private func countdownView() -> some View {
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
       }.navigationBarBackButtonHidden()
   }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .running:
            return "Run"
        default:
            return ""
        }
    }
}

#Preview {
    CourseListWatchView(navigate: .constant(true))
}
//destination: countdownView(), // 변경된 부분
//tag: workoutTypes[0],
//selection: $workoutManager.selectedWorkout
