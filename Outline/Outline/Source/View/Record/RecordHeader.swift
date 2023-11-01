//
//  RecordHeader.swift
//  Outline
//
//  Created by hyunjun on 11/2/23.
//

import SwiftUI

struct RecordHeader: View {
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Text("기록")
                .font(.title)
                .scaleEffect(max(min(1.2, 1 + (scrollOffset-47)/500), 1), anchor: .topLeading)
            Spacer()
        }
        .padding(.leading)
        .padding(.trailing)
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(scrollOffset >= 20 ? 1 : 0)
    }
}

struct RecordInlineHeader: View {
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Text("기록")
                .font(.title)
            Spacer()
        }
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
        )
        .opacity(scrollOffset < 20 ? 1 : 0)
    }
}
