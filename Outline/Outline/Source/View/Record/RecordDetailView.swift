//
//  RecordDetailView.swift
//  Outline
//
//  Created by 김하은 on 10/23/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct RecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = RecordDetailViewModel()
    
    @State private var showRenameSheet = false
    @State private var newCourseName = ""
    @State private var completeButtonActive = false
    @State private var isShowAlert = false
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @Binding var isDeleteData: Bool
    
    private let gradientColors: [Color] = [.customBlack, .customBlack, .customBlack, .customBlack, .black50, .customBlack.opacity(0)]
    private let polylineGradient = Gradient(colors: [.customGradient1, .customGradient2, .customGradient3])
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var record: CoreRunningRecord
    
    var body: some View {
        ZStack {
            Color.gray900
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            LinearGradient(
                colors: [.customBlack, .gray900],
                startPoint: .top,
                endPoint: .center
                )
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        Map {
                            MapPolyline(coordinates: viewModel.userLocations)
                                .stroke(polylineGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        }
                        .roundedCorners(45, corners: .bottomRight)
                        .shadow(color: .customWhite, radius: 1.5)
                        
                        HStack(alignment: .top) {
                            courseInfo
                            Spacer()
                            Button {
                                showRenameSheet = true
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundStyle(Color.customWhite)
                                    .font(.system(size: 24))
                            }
                            .padding(.top, 25)
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
                    
                    Button {
                        viewModel.saveShareData()
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.customPrimary)
                            .frame(height: 55)
                            .padding(.horizontal, 16)
                            .overlay {
                                Text("자랑하기")
                                    .foregroundStyle(Color.customPrimary)
                                    .font(.button)
                            }
                    }
                    
                    Text(viewModel.runningData["시간"] ?? "0:0.0")
                        .font(.timeTitle)
                        .foregroundColor(.customPrimary)
                        .monospacedDigit()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.vertical, 40)
                    
                    runningData
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                }
            }
        }
        .alert("기록한 러닝이 사라져요\n정말 삭제하시겠어요?", isPresented: $isShowAlert) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {
                viewModel.deleteRunningRecord(record)
                isDeleteData = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isDeleteData = false
                }
                dismiss()
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
            updateNameSheet
        }
        .navigationTitle("\(viewModel.date)")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.customPrimary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowAlert = true
                } label: {
                    Image(systemName: "trash")
                        .font(.subtitle)
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
                .padding(.bottom, 8)
            HStack {
                Image(systemName: "calendar")
                Text("\(viewModel.startTime)-\(viewModel.endTime)")
            }
            .padding(.bottom, 4)
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
    
    private var runningData: some View {
        LazyVGrid(columns: columns, spacing: 40) {
            ForEach(["킬로미터", "BPM", "평균 페이스", "칼로리", "케이던스"], id: \.self) { key in
                VStack(alignment: .center, spacing: 4) {
                    if let data = viewModel.runningData[key] {
                        Text(data)
                            .font(.headline)
                        Text(key)
                            .font(.subBody)
                            .foregroundStyle(Color.gray500)
                    }
                }
            }
        }
    }

    private var updateNameSheet: some View {
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
                viewModel.updateRunningRecord(record, courseName: newCourseName)
                viewModel.courseName = newCourseName
                completeButtonActive = false
                showRenameSheet = false
            }
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
        .presentationDragIndicator(.visible)
        .presentationDetents([.height(330)])
        .presentationCornerRadius(35)
    }
}
