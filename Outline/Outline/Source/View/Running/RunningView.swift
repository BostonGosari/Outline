//
//  RunningView.swift
//  Outline
//
//  Created by hyebin on 10/17/23.
//

import SwiftUI

struct RunningView: View {
    
    @StateObject var locationManager = LocationManager()
    @StateObject private var viewModel = RunningViewModel()

    var body: some View {
        ZStack {
            RunningMapView(locationManager: locationManager)
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
            
            VStack(spacing: 0) {
                /*running Guid View*/
                Spacer()
                runningButtonView
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 80)
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

extension RunningView {
    private var runningButtonView: AnyView {
        switch viewModel.runningType {
        case .running:
            AnyView(
                HStack(alignment: .center) {
                    Spacer()
                    
                    Button(action: {
                        viewModel.runningType = .pause
                    }, label: {
                        Image(systemName: "pause.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.black0Color)
                            .padding(24)
                            .background(
                                Circle()
                                    .fill(Color.firstColor)
                                    .stroke(.white0, style: .init())
                            )
                    })
                    .padding(.trailing, 64)
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "scope")
                            .foregroundStyle(Color.black0Color)
                            .padding(19)
                            .background(
                                Circle()
                                    .fill(Color.white)
                            )

                    })
                    .padding(.trailing, 32)
                }
            )
        case .pause:
            AnyView(
                HStack {
                    /*longPress stop*/
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.black0Color)
                            .padding(24)
                            .background(
                                Circle()
                                    .fill(Color.white0Color)
                            )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.runningType = .running
                    }, label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.black0Color)
                            .padding(24)
                            .background(
                                Circle()
                                    .fill(Color.firstColor)
                                    .stroke(.white0, style: .init())
                            )
                    })
                }
                    .padding(.horizontal, 64)
            )
        case .stop:
            AnyView(
                EmptyView()
            )
        }
    }
}

#Preview {
    RunningView()
}
