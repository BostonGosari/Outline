//
//  NewRunningNavigationView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import SwiftUI

struct NewRunningNavigationView: View {
    @StateObject private var locationManager = LocationManager.shared
    
    var showDetailNavigation: Bool
        
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: getDirectionImage(locationManager.direction))
                    .font(.system(size: 36))
                    .padding(.leading)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("\(Int(locationManager.distance))m")
                        .font(.customTitle2)
                    Text(locationManager.direction)
                        .font(.customSubtitle)
                        .foregroundStyle(.gray500)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if showDetailNavigation {
                Rectangle()
                    .frame(width: 310, height: 1)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(.gray600)
                
                if let nextDirection = locationManager.nextDirection {
                    HStack {
                        Image(systemName: getDirectionImage(nextDirection.direction))
                            .font(.system(size: 36))
                            .padding(.leading)
                            .padding(.trailing, 5)
                    
                        VStack(alignment: .leading) {
                            Text("\(nextDirection.distance)m")
                                .font(.customTitle2)
                            Text(nextDirection.direction)
                                .font(.customSubtitle)
                                .foregroundStyle(.gray500)
                        }
                    }
                }
            }
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
    NewRunningNavigationView(showDetailNavigation: false)
}
