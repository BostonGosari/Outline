//
//  CountDown.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/20/23.
//

import SwiftUI

struct CountDown: View {
    
    @Binding var running: Bool
    @Binding var start: Bool
    @State var count = 3
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            Group {
                switch count {
                case 3:
                    Image("Number3")
                        .resizable()
                case 2:
                    Image("Number2")
                        .resizable()
                case 1:
                    Image("Number1")
                        .resizable()
                default:
                    Text("error")
                }
            }
            .scaledToFit()
            .frame(height: 180)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                count = 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                count = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                running = true
                start.toggle()
            }
        }
    }
}
