//
//  ProfileVoiceView.swift
//  Outline
//
//  Created by Seungui Moon on 11/21/23.
//

import SwiftUI

struct ProfileVoiceView: View {
    @Binding var isVoiceOniPhone: Bool
    @Binding var isVoiceOnWatch: Bool
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 26)
            List {
                Toggle(isOn: $isVoiceOniPhone) {
                    Text("iPhone 음성 피드백")
                        .font(.customSubbody)
                }
                .listRowBackground(Color.customBlack)
                .toggleStyle(SwitchToggleStyle(tint: .customGreen))
                .padding(.vertical, 10)
                
                Toggle(isOn: $isVoiceOnWatch) {
                    Text("Apple Watch 음성 피드백")
                        .font(.customSubbody)
                }
                .listRowBackground(Color.customBlack)
                .padding(.vertical, 4)
                .toggleStyle(SwitchToggleStyle(tint: .customGreen))
                .padding(.vertical, 10)
                .listRowSeparator(.hidden)
            }
            .background(.gray900)
            .navigationTitle("음성 설정")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.grouped)
        }
    }
}
