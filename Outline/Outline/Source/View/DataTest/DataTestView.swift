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
            ForEach(fireStoreManager.userList, id: \.id) { user in
                Text("\(user.nickname)")
                Text("\(user.height)")
            }
        }
    }
}

#Preview {
    DataTestView()
}
