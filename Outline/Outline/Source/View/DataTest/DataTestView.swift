//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    @EnvironmentObject var fireStoreManager: FireStoreManager
    
    var body: some View {
        VStack {
            Text("hello")
            Text("\(fireStoreManager.nickName)")
            Text("\(fireStoreManager.height)")
        }
    }
}

#Preview {
    DataTestView()
}
