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
            Image("HeaderLogo")
                .resizable()
                .scaledToFit()
                .padding(.leading, 36)
                .frame(height: 36)
            Spacer()
            Button { } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(Color.primaryColor)
            }
        }
        .padding(.trailing)
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(scrollOffset >= 20 ? 1 : 0)
    }
}

struct InlineHeader: View {
    
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Image("HeaderLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 36)
            Spacer()
            Button { } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(Color.primaryColor)
            }
        }
        .padding(.horizontal)
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
