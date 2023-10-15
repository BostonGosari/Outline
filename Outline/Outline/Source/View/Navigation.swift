//
//  Navigation.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct Navigation: View {
    
    private let title = "OUTLINE"
    @State private var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            
            GeometryReader { proxy in
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
            }
            
            LargeNavigationTitle(scrollViewOffset: scrollViewOffset, title: title)
            
            Text("\(scrollViewOffset)")
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            scrollViewOffset = value
        }
        .overlay(alignment: .top) {
            InlineNavigationTitle(scrollViewOffset: scrollViewOffset, title: title)
        }
    }
}

struct LargeNavigationTitle: View {
    var scrollViewOffset: CGFloat
    
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.purple)
        }
        .opacity(scrollViewOffset < -20 ? 0 : 1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
    }
}

struct InlineNavigationTitle: View {
    var scrollViewOffset: CGFloat
    
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.purple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.bottom, 5)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
        )
        .opacity(scrollViewOffset < -20 ? 1 : 0)
    }
}

#Preview {
    Navigation()
}
