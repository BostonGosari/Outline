//
//  GPSArtHomeHeader.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct GPSArtHomeHeader: View {
    var title: String
    var loading: Bool
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            if loading {
                RoundedRectangle(cornerRadius: 9.5)
                    .foregroundColor(.gray700)
                    .frame(width: 115, height: 38)
            } else {
                Text(title)
                    .font(.customTitle)
            }
            Spacer()
            if loading {
                Circle()
                    .foregroundColor(.gray700)
                    .frame(width: 30)
            } else {
                NavigationLink {
                    ProfileView()
                } label: {
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

struct GPSArtHomeInlineHeader: View {
    var loading: Bool
    var scrollOffset: CGFloat
    
    var body: some View {
        HStack {
            if loading {
                RoundedRectangle(cornerRadius: 9.5)
                    .foregroundColor(.gray700)
                    .frame(width: 42, height: 24)
            } else {
                Image("OulineLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
            }
        }
        .opacity(scrollOffset < 20 ? 1 : 0)
        .animation(.bouncy, value: scrollOffset)
        .transition(.opacity)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.top)
                .opacity(scrollOffset < 20 ? 1 : 0)
        )
    }
}

#Preview {
    GPSArtHomeInlineHeader(loading: false, scrollOffset: 0)
}
