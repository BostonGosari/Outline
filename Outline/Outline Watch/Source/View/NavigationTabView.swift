//
//  NavigationTabView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

struct NavigationTabView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            smallNavigation
                .tag(0)
            bigNavigation
                .tag(1)
        }
        .tabViewStyle(.verticalPage(transitionStyle: .blur))
    }
    
    var smallNavigation: some View {
        HStack {
            Image(systemName: "arrow.turn.up.right")
                .font(.system(size: 24))
            Text("경로를 따라 계속 이동")
                .font(.customSubTitle)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.ultraThinMaterial)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
    
    var bigNavigation: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Image(systemName: "arrow.turn.up.right")
                            .font(.system(size: 26))
                        VStack(alignment: .leading) {
                            Text("60m")
                                .font(.customSubTitle)
                            Text("왼쪽에 도착지점:\n포항공과대학교 C5")
                                .font(.customBody)
                                .foregroundStyle(.gray500)
                        }
                    }
                    Rectangle()
                        .frame(width: 120, height: 1)
                        .padding(.leading, 30)
                        .foregroundStyle(.gray600)
                    HStack {
                        Image(systemName: "arrow.turn.up.right")
                            .font(.system(size: 26))
                        Text("경로를 따라 계속 이동")
                            .font(.customSubTitle)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .padding(.top, 4)
            }
            .overlay(alignment: .topLeading) {
                Button {
                    withAnimation {
                        selection = 0
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white, .gray700)
                        .font(.system(size: 40))
                        .padding(16)
                }
                .buttonStyle(.plain)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationTabView()
}
