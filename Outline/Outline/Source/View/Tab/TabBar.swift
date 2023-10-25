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
                            Image(item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                                .background {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .frame(width: 32)
                                        .foregroundStyle(.ultraThinMaterial)
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(
                                                    colors: [Color.primaryColor,
                                                             Color.primaryColor.opacity(0.5)]
                                                ),
                                                startPoint: .bottomLeading,
                                                endPoint: .topTrailing
                                            )
                                        )
                                        .frame(width: 26)
                                        .opacity(selectedTab == item.tab ? 1 : 0)
                                        .rotationEffect(selectedTab == item.tab ? .degrees(15) : .degrees(0), anchor: .bottomTrailing)
                                        .animation(.bouncy, value: selectedTab)
                                }
                            Text(item.text)
                                .font(.system(size: tabTextSize))
                        }
                        .foregroundStyle(selectedTab == item.tab ? .primaryColor : Color("Gray400"))
                    }
                    .buttonStyle(TabButtonStyle())
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 37)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundStyle(.ultraThinMaterial)
            )
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(Color.gray400Color, lineWidth: 1)
            }
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
    HomeTabView()
}
