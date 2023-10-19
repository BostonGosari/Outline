//
//  FinalWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 10/19/23.
//

import SwiftUI

struct FinalWatchView: View {
    
    @State var counter = 0
    @Namespace var bottomID
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ConfettiWatchView()
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .padding()
                    Text("그림을 완성했어요!")
                        .padding(.bottom)
                    Button("완료") {
                        // finish action
                    }
                    .id(bottomID)
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            proxy.scrollTo(bottomID, anchor: .top)
                        }
                    }
                }
            }
            .navigationTitle("시티런")
        }
    }
}

#Preview {
    FinalWatchView()
}
