//
//  RecordListHeaderView.swift
//  Outline
//
//  Created by hyunjun on 8/14/24.
//

import SwiftUI

struct RecordListHeaderView: View {
    @ObservedObject var viewModel: RecordViewModel
    let type: ListType

    var title: String {
        switch type {
        case .main: ""
        case .gpsArt: "GPS 아트"
        case .free: "자유 러닝"
        }
    }
    
    var records: [RunningRecord] {
        switch type {
        case .main: viewModel.recentRunningRecords
        case .gpsArt: viewModel.gpsArtRunningRecords
        case .free: viewModel.freeRunningRecords
        }
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.customTitle2)
                .padding(.horizontal)
            Spacer()
            NavigationLink {
                RecordGridView(viewModel: viewModel, title: title, runningRecords: records)
            } label: {
                Text("View All")
                    .font(.customCaption)
                    .foregroundStyle(Color.customPrimary)
                    .padding(.horizontal)
            }
        }
    }
}
