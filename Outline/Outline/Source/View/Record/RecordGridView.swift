//
//  RecordGridView.swift
//  Outline
//
//  Created by 김하은 on 11/22/23.
//
import CoreLocation
import SwiftUI

enum SortOption: String, CaseIterable {
    case highscore = "스코어 순"
    case latest = "최신순"
    case oldest = "오래된 순"
    case longestDistance = "최장 거리"
    case shortestDistance = "최단 거리"
    
    var buttonLabel: String {
        return rawValue
    }
}

struct RecordGridView: View {
    var title: String
    var records: [CoreRunningRecord]
    @State private var isDeleteData = false
    @State private var selectedSortOption: SortOption = .latest
    
    @State private var isSortingSheetPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.customTitle)
                    .padding(.horizontal)
                Spacer()
                // Dropdown button for sorting
                Button {
                       isSortingSheetPresented.toggle()
                   } label: {
                       Label(selectedSortOption.buttonLabel, systemImage: "arrow.up.arrow.down")
                           .font(.customSubbody)
                           .foregroundStyle(Color.customPrimary)
                           .padding(.horizontal)
                   }
                   .padding(.horizontal)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(records.sorted(by: sortRecords), id: \.id) { record in
                        NavigationLink {
                            RecordDetailView(isDeleteData: $isDeleteData, record: record)
                                .navigationBarBackButtonHidden()
                        } label: {
                            if let courseName = record.courseData?.courseName,
                               let coursePaths = record.courseData?.coursePaths,
                               let startDate = record.healthData?.startDate {
                                    let data = pathToCoordinate(coursePaths)
                                SmallListCard(cardType: .freeRun, runName: courseName, date: formatDate(startDate), data: data! )
                                }
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $isSortingSheetPresented) {
            VStack(alignment: .leading) {
                // Existing code for sheet header

                Text("정렬")
                    .font(.customSubtitle)
                    .padding(.top, 22)
                Divider()
                    .foregroundStyle(Color.gray600)
                    .padding(.top, 8)

                // Sorting options based on the selected sort option
                ForEach(sortingOptions(for: title), id: \.self) { option in
                    Button {
                        selectedSortOption = option
                        isSortingSheetPresented.toggle()
                    } label: {
                        HStack {
                            Text(option.buttonLabel)
                                .font(.customSubbody)
                                .foregroundStyle(selectedSortOption.buttonLabel == option.rawValue ? Color.customPrimary : Color.gray500)
                            Spacer()
                            if selectedSortOption.buttonLabel == option.rawValue {
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

                // Button to dismiss the sheet
                Button {
                    isSortingSheetPresented.toggle()
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
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 60, trailing: 16))
            .ignoresSafeArea()
            .presentationDragIndicator(.hidden)
            .presentationDetents([.height(375)])
            .presentationCornerRadius(35)
        }
        .onAppear(){
            selectedSortOption = self.title == "GPS 아트" ? .highscore : .latest
        }
        .overlay {
            if isDeleteData {
                RunningPopup(text: "기록을 삭제했어요")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }

    // Helper method to get sorting options based on the title
    func sortingOptions(for title: String) -> [SortOption] {
        switch title {
        case "GPS 아트":
            return [.highscore, .latest, .oldest]
        case "자유러닝":
            return [.latest, .oldest, .longestDistance]
        default:
            return SortOption.allCases
        }
    }
    
    func getCardType(forScore score: Int32) -> CardType {
        switch Int(score) {
        case -1:
            return .freeRun
        case 0...50:
            return .nice
        case 51...80:
            return .great
        case 81...100:
            return .excellent
        default:
            return .freeRun // Add a default case or handle as needed
        }
    }
   
    private func sortRecords(record1: CoreRunningRecord, record2: CoreRunningRecord) -> Bool {
        switch selectedSortOption {
        case .latest:
            return record1.healthData?.startDate ?? Date() > record2.healthData?.startDate ?? Date()
        case .oldest:
            return record1.healthData?.startDate ?? Date() < record2.healthData?.startDate ?? Date()
        case .longestDistance:
            return record1.healthData?.totalRunningDistance ?? 0 > record2.healthData?.totalRunningDistance ?? 0
        case .shortestDistance:
            return record1.healthData?.totalRunningDistance ?? 0 < record2.healthData?.totalRunningDistance ?? 0
        case .highscore:
            return record1.courseData?.score ?? -1 > record2.courseData?.score ?? -1
        }
    }
   
    func pathToCoordinate(_ paths: NSOrderedSet) -> [CLLocationCoordinate2D]? {
        var datas = [Coordinate]()
        paths.forEach { elem in
            if let data = elem as? CoreCoordinate {
                datas.append(Coordinate(longitude: data.longitude, latitude: data.latitude))
            }
        }
        
        return ConvertCoordinateManager.convertToCLLocationCoordinates(datas)
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }

}
