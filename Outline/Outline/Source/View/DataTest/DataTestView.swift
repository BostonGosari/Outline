//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    let userInfoModel = UserInfoModel()
    let couseModel = CourseModel()
    @State private var userInfo: UserInfo?
    
    private let uid = "41FE5C46-A040-4137-BB54-EA50AE748812"
    
    var body: some View {
        VStack {
            Text("nickname: \(userInfo?.nickname ?? "")")
            Text("height: \(userInfo?.height.description ?? "")")
            Text("weight: \(userInfo?.weight.description ?? "")")
            Text("gender: \(userInfo?.gender.rawValue ?? "")")
            Text("birthday: \(userInfo?.birthday.description ?? "")")
            Spacer()
            Button {
                userInfoModel.readUserInfo(uid: uid) { result in
                    switch result {
                    case .success(let userInfo):
                        print(userInfo)
                        self.userInfo = userInfo
                    case .failure(let error):
                        print(error)
                    }
                }
            } label: {
                Text("readUserInfo")
            }
            Button {
                userInfoModel.updateUserInfo(uid: uid, userInfo: UserInfo(nickname: "moon", birthday: Date(), height: 120, weight: 100)) { result in
                    switch result {
                    case .success(let isSuccess):
                        print("\(isSuccess)")
                    case .failure(let error):
                        print(error)
                    }
                }
            } label: {
                Text("updatedUserInfo")
            }
            Button {
                userInfoModel.createUser(nickname: "joyce") { result in
                    switch result {
                    case .success(let isSuccess):
                        print("\(isSuccess)")
                    case .failure(let error):
                        print(error)
                    }
                }
            } label: {
                Text("createUserInfo")
            }
            Button {
                userInfoModel.deleteUser(uid: uid) { result in
                    switch result {
                    case .success(let isSuccess):
                        print("\(isSuccess)")
                    case .failure(let error):
                        print(error)
                    }
                }
            } label: {
                Text("deleteUser")
            }
            Button {
                couseModel.readAllCourses { result in
                    switch result {
                    case .success(let courseList):
                        print(courseList)
                    case .failure(let error):
                        print(error)
                    }
                }
            } label: {
                Text("readAllCourses")
            }
            Button {
                couseModel.readCourse(id: "an3yE14Ue1xsUKlDwUZu") { result in
                    switch result {
                    case .success(let courseList):
                        print(courseList)
                    case .failure(let error):
                        print(error)
                    }
                }
            } label: {
                Text("readAllCourses")
            }
        }
    }
}

#Preview {
    DataTestView()
}
