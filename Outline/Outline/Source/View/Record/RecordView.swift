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
                    
                    RecordHeader(scrollOffset: viewModel.scrollOffset)
                    
                    if runningRecords.isEmpty {
                        RecordEmptyRunningView()
                    } else {
                        LazyVStack(alignment: .leading) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(viewModel.recentRunningRecords.prefix(5), id: \.id) { runningRecord in
                                        let courseData = runningRecord.courseData
                                        let healthData = runningRecord.healthData
                                        let cardType = viewModel.getCardType(for: courseData.score)
                                            NavigationLink {
                                                RecordDetailView(viewModel: viewModel, runningRecord: runningRecord, cardType: cardType)
                                            } label: {
                                                RecordCardView(size: .carousel, type: cardType, name: courseData.courseName, date: healthData.startDate.dateToShareString(), coordinates: courseData.coursePaths)
                                            }
                                            .padding(.bottom, 8)
                                    }
                                    
                                    ForEach(0 ..< max(0, 5 - viewModel.recentRunningRecords.count), id: \.self) { _ in
                                        RecordEmptyCardView(size: .carousel)
                                    }
                                }
                                .padding(.horizontal)
                                
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("GPS 아트")
                                        .font(.customTitle2)
                                        .padding(.horizontal)
                                    Spacer()
                                    NavigationLink {
                                        RecordGridView(viewModel: viewModel, title: "GPS 아트", runningRecords: viewModel.gpsArtRunningRecords)
                                            .navigationBarTitleDisplayMode(.inline)
                                    } label: {
                                        Text("View All")
                                            .font(.customCaption)
                                            .foregroundStyle(Color.customPrimary)
                                            .padding(.horizontal)
                                    }
                                }
                                LazyHStack(spacing: 16) {
                                    ForEach(viewModel.gpsArtRunningRecords.prefix(3), id: \.id) { runningRecord in
                                        let courseData = runningRecord.courseData
                                        let healthData = runningRecord.healthData
                                        let cardType = viewModel.getCardType(for: runningRecord.courseData.score)
                                            NavigationLink {
                                                RecordDetailView(viewModel: viewModel, runningRecord: runningRecord, cardType: cardType)
                                            } label: {
                                                RecordCardView(size: .list, type: cardType, name: courseData.courseName, date: healthData.startDate.dateToShareString(), coordinates: courseData.coursePaths)
                                            }
                                    }
                                    
                                    Group {
                                        ForEach(0 ..< max(0, 3 - viewModel.gpsArtRunningRecords.count), id: \.self) { _ in
                                            RecordEmptyCardView(size: .list)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 48)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("자유러닝")
                                        .font(.customTitle2)
                                        .padding(.horizontal)
                                    Spacer()
                                    NavigationLink {
                                        RecordGridView(viewModel: viewModel, title: "자유러닝", runningRecords: viewModel.freeRunningRecords)
                                            .navigationBarTitleDisplayMode(.inline)
                                    } label: {
                                        Text("View All")
                                            .font(.customCaption)
                                            .foregroundStyle(Color.customPrimary)
                                            .padding(.horizontal)
                                    }
                                    
                                }
                                
                                LazyHStack(spacing: 16) {
                                    ForEach(viewModel.freeRunningRecords.prefix(3), id: \.id) { runningRecord in
                                        let courseData = runningRecord.courseData
                                        let healthData = runningRecord.healthData
                                        let cardType = viewModel.getCardType(for: runningRecord.courseData.score)
                                            NavigationLink {
                                                RecordDetailView(viewModel: viewModel, runningRecord: runningRecord, cardType: cardType)
                                            } label: {
                                                RecordCardView(size: .list, type: cardType, name: courseData.courseName, date: healthData.startDate.dateToShareString(), coordinates: courseData.coursePaths)
                                        }
                                    }
                                    
                                    ForEach(0 ..< max(0, 3 - viewModel.freeRunningRecords.count), id: \.self) { _ in
                                        RecordEmptyCardView(size: .list)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 40)
                            
                            .padding(.bottom, 100)
                        }
                        .padding(.top, 12)
                    }
                }
                .overlay(alignment: .top) {
                    RecordInlineHeader(scrollOffset: viewModel.scrollOffset)
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
