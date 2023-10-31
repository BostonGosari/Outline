//
//  TabBar.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/14/23.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack {
            HStack {
                ForEach(tabItems) { item in
                    TabBarButton(selectedTab: $selectedTab, item: item)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 11)
            .padding(.bottom, 34)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundStyle(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color.gray400, lineWidth: 1)
                    )
            )
        }
    }
}

struct TabBarButton: View {
    
    @Binding var selectedTab: Tab
    let item: TabItem
    
    var body: some View {
        Button {
            selectedTab = item.tab
        } label: {
            VStack(spacing: 5) {
                TabBarIcon(selectedTab: $selectedTab, item: item)
                Text(item.text)
                    .font(.caption2)
                    .foregroundColor(selectedTab == item.tab ? .customPrimary : .gray400)
            }
        }
        .buttonStyle(TabButtonStyle())
    }
}

struct TabBarIcon: View {
    
    @Binding var selectedTab: Tab
    let item: TabItem
    
    var body: some View {
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
                                colors: [Color.customPrimary, Color.customPrimary.opacity(0.5)]
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
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    HomeTabView()
}
