//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    @StateObject var firstoreManager = FirstoreManager()
    
    private let uid = "41FE5C46-A040-4137-BB54-EA50AE748812"
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                firstoreManager.readUserInfo(uid: uid)
            } label: {
                Text("readUserInfo")
            }
            Button {
                firstoreManager.updateUserInfo(uid: uid, userInfo: UserInfo(nickname: "austin", birthday: Date(), height: 170, weight: 50))
            } label: {
                Text("updatedUserInfo")
            }
            Button {
                firstoreManager.createUser(nickname: "newName")
            } label: {
                Text("createUserInfo")
            }
            Button {
                firstoreManager.deleteUser(uid: uid)
            } label: {
                Text("deleteUser")
            }
            Button {
                firstoreManager.readAllCourses()
            } label: {
                Text("readAllCourses")
            }
            Button {
                firstoreManager.readCourse(id: "")
            } label: {
                Text("readAllCourses")
            }
        }
    }
}

#Preview {
    DataTestView()
}
