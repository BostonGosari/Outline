//
//  FinishRunningView.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import SwiftUI

struct FinishRunningView: View {
    @StateObject private var runningManager = RunningStartManager.shared
    @StateObject private var viewModel = FinishRunningViewModel()
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: []) var runningRecord: FetchedResults<CoreRunningRecord>
    
    @State private var showRenameSheet = false
    @State private var newCourseName = ""
    @State private var completeButtonActive = false
    
    @State private var save = false
    
    var body: some View {
        NavigationStack {
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
                        cardType: viewModel.cardType,
                        runName: viewModel.courseName,
                        date: viewModel.date,
                        editMode: runningManager.runningType == .free,
                        time: viewModel.runningData[1].data,
                        distance: "\(viewModel.runningData[0].data)KM",
                        pace: viewModel.runningData[2].data,
                        kcal: viewModel.runningData[4].data,
                        bpm: viewModel.runningData[3].data,
                        score: Int(viewModel.runningData[6].data) ?? 77,
                        editAction: {
                            showRenameSheet = true
                        },
                        content: {
                            FinishRunningMapView(userLocations: viewModel.userLocations)
                        }
                    )
                    .padding(.top, getSafeArea().bottom == 0 ? 20 : 90)
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
                .navigationDestination(isPresented: $viewModel.navigateToShareMainView) {
                    ShareView(runningData: viewModel.shareData)
                        .navigationBarBackButtonHidden()
                }
                .onAppear {
                    if !save {
                        viewModel.isShowPopup = true
                        viewModel.readData(runningRecord: runningRecord)
                        save = true
                    }
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
                if let record = runningRecord.last {
                    viewModel.updateRunningRecord(record, courseName: newCourseName)
                    viewModel.courseName = newCourseName
                }
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
