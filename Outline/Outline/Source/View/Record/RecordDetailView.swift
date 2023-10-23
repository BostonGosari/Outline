//
//  RecordDetailView.swift
//  Outline
//
//  Created by 김하은 on 10/23/23.
//

import SwiftUI
import CoreLocation

struct RecordDetailView: View {
    var record: CoreRunningRecord
    var gradientColors: [Color] = [.blackColor, .blackColor, .blackColor, .blackColor, .black50Color, .blackColor.opacity(0)]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900Color
                    .ignoresSafeArea()
                VStack {
                    ZStack(alignment: .topLeading) {
//                        FinishRunningMap(userLocations: record.courseData?.coursePaths)
//                            .roundedCorners(45, corners: .bottomLeft)
//                            .shadow(color: .whiteColor, radius: 1.5)
//                        courseInfo(record: record)
//                            .background(
//                                LinearGradient(
//                                    colors: gradientColors,
//                                    startPoint: .top,
//                                    endPoint: .bottom
//                                )
//                            )
                    }
                    .ignoresSafeArea()
                    
                    runningData
                        .padding(.top, 32)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                    
                    CompleteButton(text: "자랑하기") {
                        // MoveTo shareView
                    }
                    .padding(.bottom, 16)
                }
            }
                        .navigationTitle(formatDate(record.healthData?.startDate ?? Date()))
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

extension RecordDetailView {
    private var courseInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(record.courseData?.courseName ?? "")
                .font(.headline)
            
            HStack {
                Image(systemName: "calendar")
                if let startDate = record.healthData?.startDate {
                    Text(formatDate(startDate))
                        .font(Font.caption)
                        .foregroundColor(Color.gray200)
                 
                }
            }
            .font(.subBody)
            .foregroundStyle(Color.gray200Color)
            
            HStack {
                Image(systemName: "mappin")
                    .foregroundStyle(Color.gray400Color)
                
//                Text("\(viewModel.courseRegion)")
//                    .foregroundStyle(Color.gray200Color)
            }
            .font(.subBody)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 100)
        .padding(.leading, 16)
    }
    
    private var runningData: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        
        return LazyVGrid(columns: columns) {
            ForEach((0...5), id: \.self) { _ in
                VStack(alignment: .center) {
                    Text(String(record.healthData?.totalTime ?? 10.0))
                        .font(.title2)
                    Text("시간")
                        .font(.subBody)
                }
                .padding(.bottom, 16)
            }
        }
    }
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
