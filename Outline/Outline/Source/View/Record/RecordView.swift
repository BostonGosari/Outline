//
//  RecordView.swift
//  Outline
//
//  Modified by hyunjun on 8/4/24.
//

import CoreLocation
import SwiftUI

struct RecordView: View {
    @AppStorage("authState") var authState: AuthState = .logout
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: []) var runningRecord: FetchedResults<CoreRunningRecord>
    @State private var selectedIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var filteredRecords: [CoreRunningRecord] = []
    @State private var gpsArtRecords: [CoreRunningRecord] = []
    @State private var freeRecords: [CoreRunningRecord] = []
    @State private var selectedSortOption: SortOption = .latest
    @State private var isDeleteData = false
    @State private var navigationTitle = "모든 아트"
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray900
                .ignoresSafeArea()
            BackgroundBlur(color: Color.customSecondary, padding: 50)
                .opacity(0.5)
            
            if authState == .login {
                ScrollView {
                    Color.clear.frame(height: 0)
                        .onScrollViewOffsetChanged { offset in
                            scrollOffset = offset
                        }
                    
                    RecordHeader(scrollOffset: scrollOffset)
                    
                    if filteredRecords.isEmpty {
                        VStack(alignment: .center) {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundStyle(Color.customPrimary)
                                .font(Font.system(size: 36))
                                .padding(.top, 150)
                            Text("아직 러닝 기록이 없어요")
                                .font(.customSubbody)
                                .foregroundStyle(Color.gray500)
                                .padding(.top, 14)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        LazyVStack(alignment: .leading) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(filteredRecords.prefix(5), id: \.id) { record in
                                        if let courseName = record.courseData?.courseName,
                                           let coursePaths = record.courseData?.coursePaths,
                                           let startDate = record.healthData?.startDate,
                                           let score = record.courseData?.score {
                                            let data = pathToCoordinate(coursePaths)
                                            let cardType = getCardType(forScore: score)
                                            NavigationLink {
                                                RecordDetailView(isDeleteData: $isDeleteData, record: record, cardType: cardType)
                                            } label: {
                                                RecordCardView(size: .carousel, type: cardType, name: courseName, date: formatDate(startDate), coordinates: data!)
                                            }
                                            .padding(.bottom, 8)
                                        }
                                    }
                                    
                                    ForEach(0 ..< max(0, 5 - filteredRecords.count), id: \.self) { _ in
                                        RecordEmptyCardView(size: .carousel)
                                    }
                                }
                                .padding(.horizontal)
                                
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("GPS 아트")
                                        .font(.customTitle2)
                                        .padding(.horizontal)
                                    Spacer()
                                    NavigationLink {
                                        RecordGridView(title: "GPS 아트", records: gpsArtRecords)
                                            .navigationBarTitleDisplayMode(.inline)
                                    } label: {
                                        Text("View All")
                                            .font(.customCaption)
                                            .foregroundStyle(Color.customPrimary)
                                            .padding(.horizontal)
                                    }
                                }
                                LazyHStack(spacing: 16) {
                                    ForEach(gpsArtRecords.prefix(3), id: \.id) { record in
                                        if let courseName = record.courseData?.courseName,
                                           let coursePaths = record.courseData?.coursePaths,
                                           let startDate = record.healthData?.startDate,
                                           let score = record.courseData?.score {
                                            let data = pathToCoordinate(coursePaths)
                                            let cardType = getCardType(forScore: score)
                                            NavigationLink {
                                                RecordDetailView(isDeleteData: $isDeleteData, record: record, cardType: cardType)
                                            } label: {
                                                RecordCardView(size: .list, type: cardType, name: courseName, date: formatDate(startDate), coordinates: data!)
                                            }
                                        }
                                    }
                                    
                                    // Use Group to conditionally include SmallListEmptyCard
                                    Group {
                                        ForEach(0 ..< max(0, 3 - gpsArtRecords.count), id: \.self) { _ in
                                            RecordEmptyCardView(size: .list)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 48)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("자유러닝")
                                        .font(.customTitle2)
                                        .padding(.horizontal)
                                    Spacer()
                                    NavigationLink {
                                        RecordGridView(title: "자유러닝", records: freeRecords)
                                            .navigationBarTitleDisplayMode(.inline)
                                    } label: {
                                        Text("View All")
                                            .font(.customCaption)
                                            .foregroundStyle(Color.customPrimary)
                                            .padding(.horizontal)
                                    }
                                    
                                }
                                
                                LazyHStack(spacing: 16) {
                                    ForEach(freeRecords.prefix(3), id: \.id) { record in
                                        if let courseName = record.courseData?.courseName,
                                           let coursePaths = record.courseData?.coursePaths,
                                           let startDate = record.healthData?.startDate,
                                           let score = record.courseData?.score {
                                            let data = pathToCoordinate(coursePaths)
                                            let cardType = getCardType(forScore: score)
                                            NavigationLink {
                                                RecordDetailView(isDeleteData: $isDeleteData, record: record, cardType: cardType)
                                            } label: {
                                                RecordCardView(size: .list, type: cardType, name: courseName, date: formatDate(startDate), coordinates: data!)                                            }
                                        }
                                    }
                                    
                                    ForEach(0 ..< max(0, 3 - freeRecords.count), id: \.self) { _ in
                                        RecordEmptyCardView(size: .list)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 40)
                            
                            .padding(.bottom, 100)
                        }
                        .padding(.top, 12)
                    }
                }
                .overlay(alignment: .top) {
                    RecordInlineHeader(scrollOffset: scrollOffset)
                }
            } else {
                VStack {
                    RecordHeader(scrollOffset: 47)
                        .padding(.top, 8)
                    Spacer()
                    LookAroundView(type: .record)
                    Spacer()
                }
            }
        }
        .onAppear {
            filteredRecords = Array(runningRecord)
                .sorted { $0.healthData?.startDate ?? Date() > $1.healthData?.startDate ?? Date() }
            
            gpsArtRecords = filteredRecords
                .filter { $0.runningType == "gpsArt" }
                .sorted { $0.courseData?.score ?? -1 > $1.courseData?.score ?? -1 }
            
            freeRecords = filteredRecords
                .filter { $0.runningType == "free" }
                .sorted { $0.healthData?.startDate ?? Date() > $1.healthData?.startDate ?? Date() }
            
            print("Filtered Records Count: \(filteredRecords.count)")
            print("GPS Art Records Count: \(gpsArtRecords.count)")
            print("Free Records Count: \(freeRecords.count)")
        }
        .overlay {
            if isDeleteData {
                RunningPopup(text: "기록을 삭제했어요")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
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
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func pathToCoordinate(_ paths: NSOrderedSet) -> [CLLocationCoordinate2D]? {
        var datas = [Coordinate]()
        paths.forEach { elem in
            if let data = elem as? CoreCoordinate {
                datas.append(Coordinate(longitude: data.longitude, latitude: data.latitude))
            }
        }
        
        return datas.toCLLocationCoordinates()
    }
}

#Preview {
    RecordView()
}
