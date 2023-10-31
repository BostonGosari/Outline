//
//  RecordDetailView.swift
//  Outline
//
//  Created by 김하은 on 10/23/23.
//

import CoreLocation
import SwiftUI

struct RecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = RecordDetailViewModel()
    
    @State private var showRenameSheet = false
    @State private var newCourseName = ""
    @State private var completeButtonActive = false
    
    var record: CoreRunningRecord
    var gradientColors: [Color] = [.customBlack, .customBlack, .customBlack, .customBlack, .black50, .customBlack.opacity(0)]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.customBlack, .gray900, .gray900],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        FinishRunningMap(userLocations: $viewModel.userLocations)
                            .roundedCorners(45, corners: .bottomLeft)
                            .shadow(color: .customWhite, radius: 1.5)
                        
                        HStack(alignment: .top) {
                            courseInfo
                            Spacer()
                            Button {
                                showRenameSheet = true
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundStyle(Color.customWhite)
                                    .font(.system(size: 20))
                            }
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                        }
                        .background(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .padding(.top, -2)
                        )
                    }
                    .ignoresSafeArea()
                    .frame(height: 575)
                    .padding(.bottom, 16)
                    
                    CompleteButton(text: "자랑하기", isActive: true) {
                        viewModel.saveShareData()
                    }
                    .padding(.bottom, 40)
                    
                    Text(viewModel.runningData["시간"] ?? "0:0:0")
                        .font(Font.custom("Pretendard-ExtraBold", size: 70))
                        .foregroundColor(.customPrimary)
                        .monospacedDigit()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.bottom, 16)
                    
                    LazyVGrid(columns: columns, spacing: 42) {
                        VStack(alignment: .center) {
                            if let data = viewModel.runningData["킬로미터"] {
                                Text(data)
                                    .font(.title2)
                                Text("킬로미터")
                                    .font(.subBody)
                            }
                        }
                        VStack(alignment: .center) {
                            if let data = viewModel.runningData["평균 페이스"] {
                                Text(data)
                                    .font(.title2)
                                Text("평균 페이스")
                                    .font(.subBody)
                            }
                        }
                        VStack(alignment: .center) {
                            if let data = viewModel.runningData["칼로리"] {
                                Text(data)
                                    .font(.title2)
                                Text("칼로리")
                                    .font(.subBody)
                            }
                        }
                        VStack(alignment: .center) {
                            if let data = viewModel.runningData["BPM"] {
                                Text(data)
                                    .font(.title2)
                                Text("BPM")
                                    .font(.subBody)
                            }
                        }
                        .padding(.horizontal, 51)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToShareMainView) {
            ShareMainView(runningData: viewModel.shareData)
                .navigationBarBackButtonHidden()
        }
        .onAppear {
            viewModel.readData(runningRecord: record)
        }
        .sheet(isPresented: $showRenameSheet) {
            VStack(alignment: .leading, spacing: 0) {
                Text("코스 이름 수정하기")
                    .font(.subtitle)
                    .padding(.top, 35)
                    .padding(.bottom, 48)
                    .padding(.horizontal, 16)
                
                TextField("코스 이름을 입력하세요.", text: $newCourseName)
                    .onChange(of: newCourseName) {
                        if !newCourseName.isEmpty {
                            completeButtonActive = true
                        } else {
                            completeButtonActive = false
                        }
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 16)
            
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.customPrimary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 41)
                
                CompleteButton(text: "완료", isActive: completeButtonActive) {
//                    dataModel.updateRunningRecord(record, courseName: newCourseName)
                    dismiss()
                }
                .padding(.bottom, 30)
            }
            .ignoresSafeArea()
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(330)])
            .presentationCornerRadius(35)
        }
        .navigationTitle("\(viewModel.date)")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //dataModel.deleteRunningRecord(record)
                    dismiss()
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(Color.customPrimary)
                }
            }
        }
    }
}

extension RecordDetailView {
    private var courseInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(viewModel.courseName)")
                .font(.headline)
            
            HStack {
                Image(systemName: "calendar")
                Text("\(viewModel.startTime)-\(viewModel.endTime)")
            }
            .font(.subBody)
            .foregroundStyle(Color.gray200)
            
            HStack {
                Image(systemName: "mappin")
                    .foregroundStyle(Color.gray400)
                
                Text("\(viewModel.courseRegion)")
                    .foregroundStyle(Color.gray200)
            }
            .font(.subBody)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}
