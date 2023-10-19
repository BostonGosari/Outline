//
//  UserDataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/18/23.
//

import SwiftUI

struct UserDataTestView: View {
    @ObservedObject private var dataTestViewModel = DataTestViewModel()
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: [])
    var runningRecord: FetchedResults<CoreRunningRecord>
    
    var body: some View {
        ScrollView {
            VStack {
                Text("recordData")
                    .font(.title)
                ForEach(runningRecord, id: \.id) { record in
                    Text(record.courseData?.courseName ?? "")
                        .onTapGesture {
                            dataTestViewModel.updateRunningRecord(record, courseName: "악어런")
                        }
                }
                Button {
                    dataTestViewModel.addRunningRecord()
                } label: {
                    Text("add running record")
                }

            }
        }
    }
}

#Preview {
    UserDataTestView()
}
