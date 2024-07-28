//
//  EmptyContent.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

struct EmptyContent: View {
    var body: some View {
        HStack {
            Image(systemName: "iphone")
                .foregroundStyle(.gray600, .clear)
                .font(.system(size: 24))
            Text("OUTLINE iPhone을\n실행해서 코스를 선택하세요.")
                .multilineTextAlignment(.leading)
                .font(.customCaption)
                .foregroundStyle(.gray600)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    EmptyContent()
}
