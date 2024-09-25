//
//  RecordListView.swift
//  Outline
//
//  Created by hyunjun on 8/14/24.
//

import SwiftUI

enum ListType {
    case main, gpsArt, free
}

struct RecordListView: View {
    @ObservedObject var viewModel: RecordViewModel
    let type: ListType
    
    var records: [RunningRecord] {
        switch type {
        case .main: viewModel.recentRunningRecords
        case .gpsArt: viewModel.gpsArtRunningRecords
        case .free: viewModel.freeRunningRecords
        }
    }
    
    var size: RecordCardSize {
        switch type {
        case .main: .carousel
        case .gpsArt, .free: .list
        }
    }
    
    var prefixLength: Int {
        switch type {
        case .main: 5
        case .gpsArt, .free: 3
        }
    }
    
    var body: some View {
        LazyHStack(spacing: 16) {
            ForEach(records.prefix(prefixLength), id: \.id) { record in
                let courseData = record.courseData
                let healthData = record.healthData
                let cardType = viewModel.getCardType(for: courseData.score)
                    NavigationLink {
                        RecordDetailView(viewModel: viewModel, runningRecord: record, cardType: cardType)
                    } label: {
                        RecordCardView(size: size, type: cardType, name: courseData.courseName, date: healthData.startDate.dateToShareString(), coordinates: courseData.coursePaths, heading: courseData.heading)
                    }
                    .padding(.bottom, 8)
            }
            
            ForEach(0 ..< max(0, 5 - records.count), id: \.self) { _ in
                RecordEmptyCardView(size: size)
            }
        }
        .padding(.horizontal)
    }
}
