//
//  Header.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct Header: View {
    
    var loading: Bool
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Image("HeaderLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 36)
            Spacer()
            if loading {
                Circle()
                    .foregroundColor(.gray700Color)
                    .frame(width: 30)
            } else {
                Button { } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 30))
                        .fontWeight(.light)
                        .foregroundColor(Color.primaryColor)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(scrollOffset >= 20 ? 1 : 0)
    }
}

struct InlineHeader: View {
    
    var loading: Bool
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            Image("HeaderLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 36)
            Spacer()
            if loading {
                Circle()
                    .foregroundColor(.gray700Color)
                    .frame(width: 30)
            } else {
                Button { } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 30))
                        .fontWeight(.light)
                        .foregroundColor(Color.primaryColor)
                }
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
