//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    @StateObject private var firestoreManager = FirstoreManager()
    
    var body: some View {
        VStack {
            Text("hello")
            Button{
                firestoreManager.writeUserData(nickname: "austin")
            } label: {
                Text("write")
            }
        }
    }
}

#Preview {
    DataTestView()
}
