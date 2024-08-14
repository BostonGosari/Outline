//
//  RecordEmptyRunningView.swift
//  Outline
//
//  Created by hyunjun on 8/14/24.
//

import SwiftUI

struct RecordEmptyRunningView: View {
    var body: some View {
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
    }
}

#Preview {
    RecordEmptyRunningView()
}
