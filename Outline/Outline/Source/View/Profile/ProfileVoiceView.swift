//
//  ProfileVoiceView.swift
//  Outline
//
//  Created by Seungui Moon on 11/21/23.
//

import SwiftUI

struct ProfileVoiceView: View {
    @State private var isVoiceOniPhone = true
    @State private var isVoiceOnWatch = true
    
    var body: some View {
        List {
            Toggle(isOn: $isVoiceOniPhone) {
                Text("iPhone 음성 피드백")
                    .font(.customSubbody)
            }
            .listRowBackground(Color.customBlack)
            .padding(.vertical, 30)
            Toggle(isOn: $isVoiceOnWatch) {
                Text("Apple Watch 음성 피드백")
                    .font(.customSubbody)
            }
            .listRowBackground(Color.customBlack)
            .padding(.vertical, 4)
        }
        .background(.customBlack)
        .navigationTitle("음성 설정")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(PlainListStyle())

    }
}

#Preview {
    ProfileVoiceView()
}
