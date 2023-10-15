//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    let userModel = UserModel()
    
    var body: some View {
        VStack {
            Text("hello")
            Button {
                do {
                    try userModel.readUserInfo(uid: "cfU1R5dJiooxbi7MbN4d")
                } catch {
                    print(error)
                }
                
            } label: {
                Text("read user data")
            }
        }
    }
}

#Preview {
    DataTestView()
}
