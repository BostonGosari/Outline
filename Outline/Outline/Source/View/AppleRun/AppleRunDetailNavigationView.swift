//
//  AppleRunDetailNavigationView.swift
//  Outline
//
//  Created by hyunjun on 12/3/23.
//

import AVFoundation
import SwiftUI

struct AppleRunDetailNavigationView: View {
    
    let courseName: String
    var showDetailNavigation: Bool
        
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "arrow.uturn.right")
                    .font(.system(size: 36))
                    .padding(.leading)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("\(Int(10))m")
                        .font(.customTitle2)
                    Text("한바퀴 돌아주세요")
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
            }
        }
    }
    
    private func getDirectionImage(_ direction: String) -> String {
        switch direction {
        case "우회전", "오른쪽":
            return "arrow.turn.up.right"
        case "좌회전", "왼쪽":
            return "arrow.turn.up.left"
        default:
            return "arrow.right.circle"
        }
    }
}
