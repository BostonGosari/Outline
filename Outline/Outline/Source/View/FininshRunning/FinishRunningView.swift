//
//  FinishRunningView.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import SwiftUI
import FirebaseAnalytics

struct FinishRunningView: View {
    @StateObject private var runningManager = RunningStartManager.shared
    @StateObject private var viewModel = FinishRunningViewModel()
    
    @State private var showRenameSheet = false
    @State private var newCourseName = ""
    @State private var completeButtonActive = false
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                
                VStack {
                    if let runningRecord = viewModel.runningRecord {
                        let courseData = runningRecord.courseData
                        let healthData = runningRecord.healthData
                        
                        BigCard(
                            cardType: viewModel.getCardType(for: courseData.score),
                            runName: courseData.courseName,
                            date: healthData.startDate.dateToString(),
                            editMode: runningManager.runningType == .free,
                            time: healthData.totalTime.formatMinuteSeconds(),
                            distance: "\(String(format: "%.2f", healthData.totalRunningDistance/1000))km",
                            pace: healthData.averagePace.formattedAveragePace(),
                            kcal: "\(Int(healthData.totalEnergy))",
                            bpm: "\(Int(healthData.averageHeartRate))",
                            score: courseData.score ?? 77,
                            editAction: {
                                showRenameSheet = true
                            },
                            content: {
                                MapSnapshotImageView(coordinates: runningRecord.courseData.coursePaths, width: 200, height: 400, alpha: 0.7, lineWidth: 4)
                            }
                        )
                        .padding(.top, getSafeArea().bottom == 0 ? 20 : 90)
                    }
                    Spacer()
                    CompleteButton(text: "자랑하기", isActive: true) {
                        viewModel.saveShareData()
                    }
                    .padding(.bottom, getSafeArea().bottom == 0 ? 10 : 16)
                    
                    Button(action: {
                        withAnimation {
                            runningManager.complete = false
                        }
                    }, label: {
                        Text("홈으로 돌아가기")
                            .underline(pattern: .solid)
                            .foregroundStyle(Color.gray300)
                            .font(.customSubbody)
                    })
                    .padding(.bottom, 8)
                }
                .overlay {
                    if viewModel.isShowPopup {
                        RunningPopup(text: "기록이 저장되었어요.")
                            .frame(maxHeight: .infinity, alignment: .top)
                            .transition(.move(edge: .top))
                    }
                }
                .sheet(isPresented: $showRenameSheet) {
                    updateNameSheet
                }
                .sheet(isPresented: $viewModel.navigateToShareMainView, content: {
                    ShareView(runningData: viewModel.shareData)
                        .navigationBarBackButtonHidden()
                        .edgesIgnoringSafeArea(.all)
                })
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.isShowPopup = true
                    }
                    
                    guard let healthData = viewModel.runningRecord?.healthData else { return }
                    
                    // 러닝 완료 시
                    Analytics.logEvent("finished_running", parameters: [
                        "card_name": runningManager.startCourse?.courseName ?? "자유러닝",
                        "finished_time": healthData.totalTime.formatMinuteSeconds(),
                        "finished_distance": String(format: "%.0fkm", healthData.totalRunningDistance/1000),
                        "finished_pace": healthData.averagePace.formattedAveragePace()
                    ])
                }
            }
        }
    }
}

extension FinishRunningView {
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
                viewModel.updateCoreRunningRecord(courseName: newCourseName)
                viewModel.runningRecord?.courseData.courseName = newCourseName
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

#Preview {
    FinishRunningView()
}
