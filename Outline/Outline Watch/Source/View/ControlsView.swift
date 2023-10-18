//
//  SwiftUIView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager
    var body: some View {
        VStack {
            Text(workoutManager.running ? "시티런" : "일시정지됨")
               .bold()
               .foregroundStyle(.green)
               .padding()
               .padding(.top, 5)
               .padding(.leading, 20)
               .frame(maxWidth: .infinity, alignment: .topLeading)
               .background {
                   Rectangle()
                       .foregroundStyle(.thinMaterial)
               }
            Spacer()
            HStack(spacing: 14) {
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 24))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding()
                }
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .foregroundColor(.white).opacity(0.5)
                        )
                )
                .frame(width: 80, height: 80)
                .buttonStyle(.plain)
                if workoutManager.running {
                    Button {
                        workoutManager.togglePause()
                    } label: {
                        Image(systemName: "pause")
                            .font(.system(size: 24))
                            .fontWeight(.black)
                            .foregroundColor(.first)
                            .padding()
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.first, lineWidth: 2)
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .foregroundColor(.first).opacity(0.5)
                            )
                        
                    )
                    .frame(width: 80, height: 80)
                    .buttonStyle(.plain)
                    
                } else {
                   
                    Button {
                        workoutManager.togglePause()
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                            .fontWeight(.black)
                            .foregroundColor(.first)
                            .padding()
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.first, lineWidth: 2)
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .foregroundColor(.first).opacity(0.5)
                            )
                    )
                    .frame(width: 80, height: 80)
                    .buttonStyle(.plain)
                    
                }
            }
            .frame(width: .infinity, height: .infinity)
            .padding(.bottom, 20)
            Spacer()
        }
        .ignoresSafeArea()
       
    }
    
}

#Preview {
    ControlsView().environmentObject(WatchWorkoutManager())
}
