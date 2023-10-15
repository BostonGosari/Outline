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
    
    private let uid = "cfU1R5dJiooxbi7MbN4d"
    
    var body: some View {
        VStack {
            Text("nickname: \(userInfo?.nickname ?? "")")
            Text("height: \(userInfo?.height.description ?? "")")
            Text("weight: \(userInfo?.weight.description ?? "")")
            Text("gender: \(userInfo?.gender.rawValue ?? "")")
            Text("birthday: \(userInfo?.birthday.description ?? "")")
            Spacer()
            Button {
                Task {
                    await userModel.readUserInfo(uid: uid) { result in
                        switch result {
                        case .success(let userInfo):
                            print(userInfo)
                            self.userInfo = userInfo
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            } label: {
                Text("readUserInfo")
            }
            Button {
                Task {
                    await userModel.updateUserInfo(uid: uid, userInfo: UserInfo(nickname: "moon", birthday: Date(), height: 120, weight: 100)) { result in
                        switch result {
                        case .success(let isSuccess):
                            print("\(isSuccess)")
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            } label: {
                Text("updatedUserInfo")
            }
            Button {
                Task {
                    userModel.createUser(nickname: "joyce") { result in
                        switch result {
                        case .success(let isSuccess):
                            print("\(isSuccess)")
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            } label: {
                Text("createUserInfo")
            }
            Button {
                Task {
                    userModel.deleteUser(uid: "cfU1R5dJiooxbi7MbN4d") { result in
                        switch result {
                        case .success(let isSuccess):
                            print("\(isSuccess)")
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            } label: {
                Text("deleteUser")
            }
            
        }
    }
}

#Preview {
    DataTestView()
}
