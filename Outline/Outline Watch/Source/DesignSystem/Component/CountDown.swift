//
//  CountDown.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/20/23.
//

import SwiftUI

struct CountDown: View {
    @State var count = 3
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            Group {
                switch count {
                case 3:
                    Image("Count3")
                        .resizable()
                case 2:
                    Image("Count2")
                        .resizable()
                case 1:
                    Image("Count1")
                        .resizable()
                default:
                    Text("error")
                }
            }
            .scaledToFit()
            .frame(height: 120)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                count = 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                count = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

            }
        }
    }
}

#Preview {
    CountDown()
}
