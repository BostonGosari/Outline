//
//  Header.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct Header: View {
    
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            Spacer()
            Button { } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .foregroundColor(Color.primaryColor)
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(scrollOffset >= 20 ? 1 : 0)
    }
}

struct InlineHeader: View {
    
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            Spacer()
            Button { } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .foregroundColor(Color.primaryColor)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
        )
        .opacity(scrollOffset < 20 ? 1 : 0)
    }
}
