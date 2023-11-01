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
            if loading {
                RoundedRectangle(cornerRadius: 9.5)
                    .foregroundColor(.gray700)
                    .frame(width: 115, height: 38)
            } else {
                Image("HeaderLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 36)
            }
            Spacer()
            if loading {
                Circle()
                    .foregroundColor(.gray700)
                    .frame(width: 30)
            } else {
                Button { } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 30))
                        .fontWeight(.light)
                        .foregroundColor(Color.customPrimary)
                }
            }
        }
        .padding(.leading, UIScreen.main.bounds.width * 0.08)
        .padding(.trailing)
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
                    .foregroundColor(.gray700)
                    .frame(width: 30)
            } else {
                Button { } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 30))
                        .fontWeight(.light)
                        .foregroundColor(Color.customPrimary)
                }
            }
        }
        .padding(.leading, UIScreen.main.bounds.width * 0.08)
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
