//
//  RecordGridView.swift
//  Outline
//
//  Modified by hyunjun on 8/4/24.
//

import CoreLocation
import SwiftUI

struct RecordGridView: View {
    @ObservedObject var viewModel: RecordViewModel
    var title: String
    var runningRecords: [RunningRecord]
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            
            Circle()
                .frame(maxHeight: .infinity, alignment: .bottom)
                .foregroundStyle(.customPrimary.opacity(0.5))
                .blur(radius: 150)
                .offset(y: 300)
            
            VStack(spacing: 0) {
                HStack {
                    Text(title)
                        .font(.customTitle)
                        .padding(.leading, UIScreen.main.bounds.width * 0.08)
                    Spacer()
                    
                    Button {
                        viewModel.isSortingSheetPresented.toggle()
                    } label: {
                        HStack(spacing: 0) {
                            Text(viewModel.selectedSortOption.rawValue)
                                .font(.customSubbody)
                                .foregroundStyle(Color.customPrimary)
                            
                            Image(systemName: "chevron.down")
                                .font(.customSubbody)
                                .foregroundStyle(Color.customPrimary)
                                .padding(.trailing, 4)
                        }
                    }
                    .padding(.horizontal)
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(runningRecords.sorted(by: viewModel.sortRecords), id: \.id) { runningRecord in
                            let courseData = runningRecord.courseData
                            let healthData = runningRecord.healthData
                            let cardType = viewModel.getCardType(for: courseData.score)
                            NavigationLink {
                                RecordDetailView(viewModel: viewModel, runningRecord: runningRecord, cardType: cardType)
                            } label: {
                                RecordCardView(size: .list, type: cardType, name: courseData.courseName, date: healthData.startDate.dateToShareString(), coordinates: courseData.coursePaths)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("모든 아트")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isSortingSheetPresented) {
            VStack(alignment: .leading) {
                Text("정렬")
                    .font(.customSubtitle)
                    .padding(.top, 22)
                Divider()
                    .foregroundStyle(Color.gray600)
                    .padding(.top, 8)
                
                ForEach(viewModel.sortingOptions(for: title), id: \.self) { option in
                    Button {
                        viewModel.selectedSortOption = option
                        viewModel.isSortingSheetPresented.toggle()
                    } label: {
                        HStack {
                            Text(option.rawValue)
                                .font(.customSubbody)
                                .foregroundStyle(viewModel.selectedSortOption.rawValue == option.rawValue ? Color.customPrimary : Color.gray500)
                            Spacer()
                            if viewModel.selectedSortOption.rawValue == option.rawValue {
                                Image(systemName: "checkmark")
                                    .font(.customSubbody)
                                    .foregroundStyle(Color.customPrimary)
                                    .padding(.trailing, 16)
                                    .bold()
                            }
                        }
                        .padding(.top, 16)
                    }
                }
                
                Button {
                    viewModel.isSortingSheetPresented.toggle()
                } label: {
                    Text("취소")
                        .font(.customButton)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: 55)
                        .background(Color.gray700)
                        .cornerRadius(15)
                }
                .padding(.top, 30)
            }
            .padding(EdgeInsets(top: 30, leading: 16, bottom: 50, trailing: 16))
            .ignoresSafeArea()
            .presentationDragIndicator(.hidden)
            .presentationDetents([.height(340)])
            .presentationCornerRadius(35)
        }
        .onAppear {
            viewModel.selectedSortOption = (title == "GPS 아트") ? .highscore : .latest
        }
        .overlay {
            if viewModel.isDeleteData {
                RunningPopup(text: "기록을 삭제했어요")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
