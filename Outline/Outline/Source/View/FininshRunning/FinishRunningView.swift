//
//  FinishRunningView.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import MapKit
import SwiftUI

struct FinishRunningView: View {
    @StateObject private var runningManager = RunningStartManager.shared
    @StateObject private var viewModel = FinishRunningViewModel()
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: []) var runningRecord: FetchedResults<CoreRunningRecord>
    
    @State private var showRenameSheet = false
    @State private var newCourseName = ""
    @State private var completeButtonActive = false
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var save = false
    
    private var gradientColors: [Color] = [.customBlack, .customBlack, .customBlack, .customBlack, .black50, .customBlack.opacity(0)]
    private let polylineGradient = Gradient(colors: [.customGradient1, .customGradient2, .customGradient3])
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                VStack {
                    ZStack(alignment: .topLeading) {
                        Map(interactionModes: []) {
                            MapPolyline(coordinates: viewModel.userLocations)
                                .stroke(polylineGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        }
                        .roundedCorners(45, corners: .bottomRight)
                        .shadow(color: .customWhite, radius: 0.5)

                        VStack(spacing: 0) {
                            Text("\(viewModel.date)")
                                .font(.date)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 64)
                            
                            HStack {
                                courseInfo
                                Spacer()
                                if runningManager.runningType == .free {
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
                            }
                        }
                        .background(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    .ignoresSafeArea()
                    
                    runningData
                        .padding(.top, 32)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                    
                    CompleteButton(text: "자랑하기", isActive: true) {
                        viewModel.saveShareData()
                    }
                    .padding(.bottom, 16)
                    
                    Button(action: {
                        runningManager.running = false
                    }, label: {
                        Text("홈으로 돌아가기")
                            .underline(pattern: .solid)
                            .foregroundStyle(Color.gray300)
                            .font(.subBody)
                    })
                    .padding(.bottom, 8)
                }
            }
        }
        .sheet(isPresented: $showRenameSheet) {
            updateNameSheet
        }
        .overlay {
            if viewModel.isShowPopup {
                RunningPopup(text: "기록이 저장되었어요.")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .transition(.move(edge: .top))
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToShareMainView) {
            ShareMainView(runningData: viewModel.shareData)
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

extension FinishRunningView {
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
            .padding(.top, 8)
            HStack {
                Image(systemName: "mappin")
                    .foregroundStyle(Color.gray400)
                
                Text("\(viewModel.courseRegion)")
                    .foregroundStyle(Color.gray200)
            }
            .font(.subBody)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 24)
        .padding(.leading, 16)
    }
    
    private var runningData: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        
        return LazyVGrid(columns: columns) {
            ForEach(viewModel.runningData, id: \.self) { runningData in
                VStack(alignment: .center) {
                    Text("\(runningData.data)")
                        .font(.title2)
                        .padding(.bottom, 4)
                    Text(runningData.text)
                        .font(.subBody)
                        .foregroundStyle(Color.gray500)
                }
                .padding(.bottom, 16)
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
