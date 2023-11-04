//
//  RecordView.swift
//  Outline
//
//  Created by 김하은 on 10/23/23.
//

import CoreLocation
import SwiftUI

struct RecordView: View {
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: []) var runningRecord: FetchedResults<CoreRunningRecord>
    
    @State private var selectedIndex: Int = 0
    @State private var isSortingSheetPresented = false
    @State private var selectedSortOption: SortOption = .latest
    @State private var filteredRecords: [CoreRunningRecord] = []
    @State private var scrollOffset: CGFloat = 0
    @State private var isDeleteData = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.gray900
                    .ignoresSafeArea()
                BackgroundBlur(color: Color.customSecondary, padding: 50)
                    .opacity(0.5)
                
                ScrollView {
                    Color.clear.frame(height: 0)
                        .onScrollViewOffsetChanged { offset in
                            scrollOffset = offset
                        }
                    
                    RecordHeader(scrollOffset: scrollOffset)

                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            ChipItem(label: "모두", isSelected: Binding(get: { self.selectedIndex == 0 }, set: { _ in self.selectedIndex = 0 }))
                                .padding(.trailing, 8)
                            ChipItem(label: "GPS 러닝", isSelected: Binding(get: { self.selectedIndex == 1 }, set: { _ in self.selectedIndex = 1 }))
                                .padding(.trailing, 8)
                            ChipItem(label: "자유 러닝", isSelected: Binding(get: { self.selectedIndex == 2 }, set: { _ in self.selectedIndex = 2 }))
                            Spacer()
                            Button {
                                isSortingSheetPresented = true
                            } label: {
                                HStack {
                                    Text(selectedSortOption.buttonLabel)
                                        .font(Font.subBody)
                                        .foregroundStyle(Color.customWhite)
                                    Image(systemName: "chevron.down")
                                        .font(Font.subBody)
                                        .foregroundStyle(Color.customWhite)
                                }
                            }
                        }
                        .padding(.bottom, 16)
                        if filteredRecords.isEmpty {
                            VStack(alignment: .center) {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundStyle(Color.customPrimary)
                                    .font(Font.system(size: 36))
                                    .padding(.top, 150)
                                Text("아직 러닝 기록이 없어요")
                                    .font(.subBody)
                                    .foregroundStyle(Color.gray500)
                                    .padding(.top, 14)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ForEach(filteredRecords, id: \.id) { record in
                                NavigationLink {
                                    RecordDetailView(isDeleteData: $isDeleteData, record: record)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    RecordItem(record: record)
                                }
                                .padding(.bottom, 8)
                            }
                        }
                    }
                        .padding(.horizontal)
                        .padding(.top, 12)
               
                }
                .overlay(alignment: .top) {
                    RecordInlineHeader(scrollOffset: scrollOffset)
                }
                if isSortingSheetPresented {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                }
            }
            .onChange(of: selectedSortOption) {
               updateSortDescriptors()
           }
            .onChange(of: selectedIndex) {
                updateSortDescriptors()
            }
            .onAppear {
                updateSortDescriptors()
            }
            .sheet(isPresented: $isSortingSheetPresented) {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 36, height: 5)
                            .background(Color.gray300)
                            .cornerRadius(5)
                        Spacer()
                    }
                  
                    Text("정렬")
                        .font(.subtitle)
                        .padding(.top, 22)
                    Divider()
                        .foregroundStyle(Color.gray600)
                        .padding(.top, 8)
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button {
                            selectedSortOption = option
                            isSortingSheetPresented.toggle()
                        } label: {
                            HStack {
                                Text(option.buttonLabel)
                                    .font(.subBody)
                                    .foregroundStyle(selectedSortOption.buttonLabel == option.rawValue ? Color.customPrimary : Color.gray500)
                                Spacer()
                                if selectedSortOption.buttonLabel == option.rawValue {
                                    Image(systemName: "checkmark")
                                        .font(.subBody)
                                        .foregroundStyle(Color.customPrimary)
                                        .padding(.trailing, 16)
                                        .bold()
                                }
                                   
                            }
                            .padding(.top, 16)
                        }
                    }
                    Button {
                        isSortingSheetPresented.toggle()
                    } label: {
                        Text("취소")
                            .font(.button)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: 55)
                            .background(Color.gray700)
                            .cornerRadius(15)
                    }
                    .padding(.top, 30)
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 60, trailing: 16))
                .ignoresSafeArea()
                .presentationDragIndicator(.hidden)
                .presentationDetents([.height(407)])
                .presentationCornerRadius(35)
            }
        
        }
        .overlay {
            if isDeleteData {
                RunningPopup(text: "기록을 삭제했어요")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    enum SortOption: String, CaseIterable {
        case latest = "최신순"
        case oldest = "오래된 순"
        case longestDistance = "최장 거리"
        case shortestDistance = "최단 거리"

        var buttonLabel: String {
            return rawValue
        }
    }
    
    private func updateSortDescriptors() {
        switch selectedIndex {
        case 0:
            filteredRecords = Array(runningRecord)
        case 1:
            filteredRecords = runningRecord.filter { $0.runningType == "gpsArt" }
        case 2:
            filteredRecords = runningRecord.filter { $0.runningType == "free" }
        default:
            filteredRecords = []
        }

        switch selectedSortOption {
        case .latest:
            filteredRecords.sort(by: { $0.healthData?.startDate ?? Date() > $1.healthData?.startDate ?? Date() })
        case .oldest:
            filteredRecords.sort(by: { $0.healthData?.startDate ?? Date() < $1.healthData?.startDate ?? Date() })
        case .longestDistance:
            filteredRecords.sort(by: { $0.healthData?.totalRunningDistance ?? 0 > $1.healthData?.totalRunningDistance ?? 0 })
        case .shortestDistance:
            filteredRecords.sort(by: { $0.healthData?.totalRunningDistance ?? 0 < $1.healthData?.totalRunningDistance ?? 0 })
        }
    }
}

struct RecordItem: View {
    var record: CoreRunningRecord
    var body: some View {

        ZStack {
            if let coursePath = record.courseData?.coursePaths,
               let data = pathToCoordinate(coursePath) {
                PathGenerateManager
                    .caculateLines(width: 358, height: 176, coordinates: data)
                    .stroke(lineWidth: 6)
                    .scale(0.5)
                    .foregroundStyle(Color.customPrimary)
                    .padding(.horizontal, 16)
            }
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                      if let courseName = record.courseData?.courseName {
                          Text(courseName)
                              .font(Font.title2)
                              .foregroundStyle(Color.white)
                      }

                    HStack {
                        Image(systemName: "calendar")
                            .font(Font.caption)
                            .foregroundStyle(Color.gray200)
                        if let startDate = record.healthData?.startDate {
                            Text(formatDate(startDate))
                                .font(Font.caption)
                                .foregroundStyle(Color.gray400)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
               
                Spacer()
            }
            .foregroundStyle(.clear)
            .frame(width: 358, height: 77)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .black.opacity(0), location: 0.00),
                        Gradient.Stop(color: .black.opacity(0.4), location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: -0.43),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
            .padding(.top, 100)
        }
       
        .frame(maxWidth: .infinity, maxHeight: 176)
        .background(.black.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 0.3)
                .frame(maxWidth: .infinity, maxHeight: 176)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
    
    private func pathToCoordinate(_ paths: NSOrderedSet) -> [CLLocationCoordinate2D]? {
        var datas = [Coordinate]()
        paths.forEach { elem in
            if let data = elem as? CoreCoordinate {
                datas.append(Coordinate(longitude: data.longitude, latitude: data.latitude))
            }
        }
        
        return ConvertCoordinateManager.convertToCLLocationCoordinates(datas)
    }
}

struct ChipItem: View {
    var label: String
    @Binding var isSelected: Bool

    var body: some View {
        Text(label)
            .font(Font.tag)
            .lineLimit(1)
            .padding(.horizontal, 15)
            .padding(.vertical, 6)
            .background(isSelected ? Color.customPrimary : .clear)
            .foregroundStyle(isSelected ? Color.gray900 : Color.white)
            .cornerRadius(40)
            .onTapGesture {
                self.isSelected.toggle()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(isSelected ? Color.customPrimary : Color.white, lineWidth: 1)
            )
    }
}
  
enum SortOption {
    case latest
    case oldest
    case longestDistance
    case shortestDistance
}
