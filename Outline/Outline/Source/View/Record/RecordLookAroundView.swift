//
//  RecordLookAroundView.swift
//  Outline
//
//  Created by hyunjun on 8/14/24.
//

import SwiftUI

struct RecordLookAroundView: View {
    var body: some View {
        VStack {
            RecordHeaderView(scrollOffset: 47)
                .padding(.top, 8)
            Spacer()
            LookAroundView(type: .record)
            Spacer()
        }
    }
}

#Preview {
    RecordLookAroundView()
}
