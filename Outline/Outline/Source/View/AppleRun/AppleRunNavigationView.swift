//
//  AppleRunNavigationView.swift
//  Outline
//
//  Created by hyunjun on 11/30/23.
//

import SwiftUI

struct AppleRunNavigationView: View {
    @StateObject private var appleRunManager = AppleRunManager.shared
    var showDetailNavigation: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "arrow.triangle.turn.up.right.circle")
                    .font(.system(size: 36))
                    .padding(.leading)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("630m")
                        .font(.customTitle2)
                    Text("포항공과대학교 C5")
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
                HStack {
                    Image(systemName: "arrow.triangle.turn.up.right.circle")
                        .font(.system(size: 36))
                        .padding(.leading)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading) {
                        Text("630m")
                            .font(.customTitle2)
                        Text("포항공과대학교 C5")
                            .font(.customSubtitle)
                            .foregroundStyle(.gray500)
                    }
                }
            }
        }
    }
}

#Preview {
    AppleRunNavigationView(showDetailNavigation: true)
}
