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
    var body: some View {
       
            Text(record.courseData?.courseName ?? "")
        
        .ignoresSafeArea()
      
    }
}
