//
//  RecordView.swift
//  Outline
//
//  Modified by hyunjun on 8/4/24.
//

import CoreLocation
import SwiftUI

struct RecordView: View {    
    @AppStorage("authState") var authState: AuthState = .logout
    @StateObject private var viewModel = RecordViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray900
                .ignoresSafeArea()
            BackgroundBlur(color: Color.customSecondary, padding: 50)
                .opacity(0.5)
                        
            if authState == .login {
                ScrollView {
                    Color.clear.frame(height: 0)
                        .onScrollViewOffsetChanged { offset in
                            viewModel.scrollOffset = offset
                        }
                    
                    RecordHeaderView(scrollOffset: viewModel.scrollOffset)
                    
                    if viewModel.recentRunningRecords.isEmpty {
                        RecordEmptyRunningView()
                    } else {
                        LazyVStack(alignment: .leading) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                RecordListView(viewModel: viewModel, type: .main)
                            }
                            
                            VStack(alignment: .leading) {
                                RecordListHeaderView(viewModel: viewModel, type: .gpsArt)
                                RecordListView(viewModel: viewModel, type: .gpsArt)
                            }
                            .padding(.top, 48)
                            
                            VStack(alignment: .leading) {
                                RecordListHeaderView(viewModel: viewModel, type: .free)
                                RecordListView(viewModel: viewModel, type: .free)
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 100)
                        }
                        .padding(.top, 12)
                    }
                }
                .overlay(alignment: .top) {
                    RecordInlineHeaderView(scrollOffset: viewModel.scrollOffset)
                }
            } else {
                RecordLookAroundView()
            }
        }
        .onAppear {
            viewModel.loadRunningRecords()
        }
        .overlay {
            if viewModel.isDeleteData {
                RunningPopup(text: "기록을 삭제했어요")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

#Preview {
    RecordView()
}
