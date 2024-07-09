//
//  RecordDetailView.swift
//  Outline
//
//  Created by hyunjun on 11/27/23.
//

import SwiftUI

struct RecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = RecordDetailViewModel()
        
    @State private var showRenameSheet = false
    @State private var newCourseName = ""
    @State private var completeButtonActive = false
    @State private var isShowAlert = false
    
    @Binding var isDeleteData: Bool
    
    var record: CoreRunningRecord
    var cardType: CardType
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            Circle()
                .frame(width: 350)
                .foregroundStyle(.customPrimary.opacity(0.35))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: -175, y: -100)
                .blur(radius: 120)
            Circle()
                .frame(width: 350)
                .foregroundStyle(.customPrimary.opacity(0.35))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 100, y: 100)
                .blur(radius: 120)
            
            VStack {
                BigCard(
                    cardType: cardType,
                    runName: viewModel.courseName,
                    date: viewModel.date,
                    editMode: true,
                    time: viewModel.runningData["시간"] ?? "",
                    distance: "\(viewModel.runningData["킬로미터"] ?? "")KM",
                    pace: viewModel.runningData["평균 페이스"] ?? "",
                    kcal: viewModel.runningData["칼로리"] ?? "",
                    bpm: viewModel.runningData["BPM"] ?? "",
                    score: Int(viewModel.runningData["점수"] ?? "") ?? 77,
                    editAction: {
                        showRenameSheet = true
                    },
                    content: {
                        RecordDetailMapView(userLocations: viewModel.userLocations)
                    }
                )
                .frame(maxHeight: .infinity, alignment: .center)
                
                CompleteButton(text: "자랑하기", isActive: true) {
                    viewModel.saveShareData()
                }
                .padding(.bottom, 16)
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
            .onAppear {
                viewModel.readData(runningRecord: record)
            }
            .sheet(isPresented: $showRenameSheet) {
                updateNameSheet
            }
            .sheet(isPresented: $viewModel.navigateToShareMainView) {
                ShareView(runningData: viewModel.shareData)
            }
            .preferredColorScheme(.dark)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .font(.customSubtitle)
                            .foregroundStyle(Color.customPrimary)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var updateNameSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("코스 이름 수정하기")
                .font(.customSubtitle)
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
