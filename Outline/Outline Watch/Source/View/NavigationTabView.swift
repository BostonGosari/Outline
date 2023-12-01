//
//  NavigationTabView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

struct NavigationTabView: View {
    @StateObject private var locationManager = LocationManager.shared
    
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
            Image(systemName: getDirectionImage(locationManager.direction))
                .font(.system(size: 24))
            Text("\(Int(locationManager.distance))m \(locationManager.direction)")
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
                        Image(systemName: getDirectionImage(locationManager.direction))
                            .font(.system(size: 26))
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text("\(Int(locationManager.distance))m")
                                .font(.customSubTitle)
                            Text("locationManager.direction")
                                .font(.customBody)
                                .foregroundStyle(.gray500)
                        }
                    }
                    Rectangle()
                        .frame(width: 120, height: 1)
                        .padding(.leading, 36)
                        .foregroundStyle(.gray600)
                    
                    if let nextDirection = locationManager.nextDirection {
                        HStack {
                            Image(systemName: getDirectionImage(nextDirection.direction))
                                .font(.system(size: 26))
                                .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text("\(nextDirection.distance)m")
                                    .font(.customSubTitle)
                                Text(nextDirection.direction)
                                    .font(.customBody)
                                    .foregroundStyle(.gray500)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .padding(.top, 8)
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
    
    private func getDirectionImage(_ direction: String) -> String {
        switch direction {
        case "우회전":
            return "arrow.turn.up.right"
        case "좌회전":
            return "arrow.turn.up.left"
        default:
            return ""
        }
    }
}

#Preview {
    NavigationTabView()
}
