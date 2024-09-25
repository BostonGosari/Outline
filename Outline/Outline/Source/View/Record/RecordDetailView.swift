//
//  RecordDetailView.swift
//  Outline
//
//  Modified by hyunjun on 8/4/24.
//

import SwiftUI

struct RecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RecordViewModel
    
    var runningRecord: RunningRecord
    var cardType: CardType
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            VStack {
                let courseData = runningRecord.courseData
                let healthData = runningRecord.healthData
                
                BigCard(
                    cardType: cardType,
                    runName: courseData.courseName,
                    date: healthData.startDate.dateToString(),
                    editMode: true,
                    time: healthData.totalTime.formatMinuteSeconds(),
                    distance: "\(String(format: "%.2f", healthData.totalRunningDistance/1000))km",
                    pace: healthData.averagePace.formattedAveragePace(),
                    kcal: "\(Int(healthData.totalEnergy))",
                    bpm: "\(Int(healthData.averageHeartRate))",
                    score: courseData.score ?? 77,
                    editAction: {
                        viewModel.showRenameSheet = true
                    },
                    content: {
                        MapSnapshotImageView(coordinates: courseData.coursePaths, width: 200, height: 400, alpha: 0.7, lineWidth: 4, heading: courseData.heading)
                    }
                )
                .frame(maxHeight: .infinity, alignment: .center)
                
                CompleteButton(text: "자랑하기", isActive: true) {
                    viewModel.navigateToShareMainView = true
                    viewModel.saveShareData(runningRecord)
                }
                .padding(.bottom, 16)
            }
            .alert("기록한 러닝이 사라져요\n정말 삭제하시겠어요?", isPresented: $viewModel.isShowAlert) {
                Button("취소", role: .cancel) {}
                Button("삭제", role: .destructive) {
                    viewModel.deleteCoreRunningRecord(runningRecord.id)
                    viewModel.isDeleteData = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        viewModel.isDeleteData = false
                    }
                    dismiss()
                }
            }
            .sheet(isPresented: $viewModel.showRenameSheet) {
                updateNameSheet
            }
            .sheet(isPresented: $viewModel.navigateToShareMainView, content: {
                ShareView(runningData: viewModel.shareData)
                    .navigationBarBackButtonHidden()
                    .edgesIgnoringSafeArea(.all)
            })
            .preferredColorScheme(.dark)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .font(.customSubtitle)
                            .foregroundStyle(Color.customPrimary)
                    }
                }
            }
        }
    }
    
    private var updateNameSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("코스 이름 수정하기")
                .font(.customSubtitle)
                .padding(.top, 35)
                .padding(.bottom, 48)
                .padding(.horizontal, 16)
            
            TextField("코스 이름을 입력하세요.", text: $viewModel.newCourseName)
                .onChange(of: viewModel.newCourseName) {
                    if !viewModel.newCourseName.isEmpty {
                        viewModel.completeButtonActive = true
                    } else {
                        viewModel.completeButtonActive = false
                    }
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
        
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.customPrimary)
                .padding(.horizontal, 16)
                .padding(.bottom, 41)
            
            CompleteButton(text: "완료", isActive: viewModel.completeButtonActive) {
                viewModel.updateCoreRunningRecord(runningRecord.id, courseName: viewModel.newCourseName)
                viewModel.completeButtonActive = false
                viewModel.showRenameSheet = false
            }
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
        .presentationDragIndicator(.visible)
        .presentationDetents([.height(330)])
        .presentationCornerRadius(35)
    }
}
