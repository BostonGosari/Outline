//
//  TabBar.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var selectedTab: Tab
        
    private let tabIconSize: CGFloat = 18
    private let tabTextSize: CGFloat = 10
    
    var body: some View {
        VStack {
            HStack {
                ForEach(tabItems) { item in
                    Button {
                        selectedTab = item.tab
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: item.icon)
                                .font(.system(size: tabIconSize))
                            Text(item.text)
                                .font(.system(size: tabTextSize))
                        }
                        .foregroundStyle(selectedTab == item.tab ? .primaryColor : Color("Gray400"))
                    }
                    .buttonStyle(TabButtonStyle())
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 11)
            .padding(.bottom, 30)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.ultraThinMaterial)
            )
        }
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

#Preview {
    TabBar(selectedTab: .constant(Tab.GPSArtRunning))
}
