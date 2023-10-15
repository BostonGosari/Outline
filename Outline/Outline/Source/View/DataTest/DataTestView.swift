//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    let userModel = UserModel()
    @State private var userInfo: UserInfo?
    
    var body: some View {
        VStack {
            Text("\(userInfo?.nickname ?? "")")
            Button {
                Task {
                    await userModel.readUserInfo(uid: "cfU1R5dJiooxbi7MbN4d") { result in
                        switch result {
                        case .success(let userInfo):
                            self.userInfo = userInfo
                        case .failure(let error):
                            print(error)
                        }
                    }
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
