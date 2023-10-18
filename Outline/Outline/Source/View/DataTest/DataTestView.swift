//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    @ObservedObject private var dataTestViewModel = DataTestViewModel()
    private let courseId = "an3yE14Ue1xsUKlDwUZu"
    
    var body: some View {
        VStack {
            Text("user")
                .font(.title)
            Text("nickname: \(dataTestViewModel.userInfo.nickname)")
            Text("weight: \(dataTestViewModel.userInfo.weight)")
            Text("height: \(dataTestViewModel.userInfo.height)")
            Text("gender: \(dataTestViewModel.userInfo.gender.rawValue)")
            Text("course")
                .font(.title)
            VStack {
                ScrollView {
                    ForEach(dataTestViewModel.courses, id: \.id) { course in
                        Text("courseName: \(course.courseName)")
                        Text("courseDuration: \(course.courseDuration)")
                        Text("courseLength: \(course.courseLength)")
                        Text("distance: \(course.distance)")
                        Text("heading: \(course.heading)")
                        Text("alley: \(course.alley.rawValue)")
                        Text("centerLocation: \(course.centerLocation.latitude), \(course.centerLocation.longitude), ")
                        Text("level: \(course.level.rawValue)")
                        Text("thumanail: \(course.thumbnail)")
                    }
                }
            }
            Spacer()
            Button {
                dataTestViewModel.readUserInfo(uid: dataTestViewModel.uid)
            } label: {
                Text("readUserInfo")
            }
            Button {
                dataTestViewModel.updateUserInfo(uid: dataTestViewModel.uid, userInfo: UserInfo(nickname: "austin", birthday: Date(), height: 120, weight: 10))
            } label: {
                Text("updatedUserInfo")
            }
            Button {
                dataTestViewModel.createUser(nickname: "newName")
            } label: {
                Text("createUserInfo")
            }
            Button {
                dataTestViewModel.deleteUser(uid: dataTestViewModel.uid)
            } label: {
                Text("deleteUser")
            }
            Button {
                dataTestViewModel.readAllCourses()
            } label: {
                Text("readAllCourses")
            }
            Button {
                dataTestViewModel.readCourse(id: courseId)
            } label: {
                Text("readCourse")
            }
            Button {
                dataTestViewModel.readUserNameSet()
            } label: {
                Text("readUserNameSet")
            }
            Button {
                dataTestViewModel.updateUserNameSet(userNameFrom: "문의", userNameTo: "오스틴")
            } label: {
                Text("updateNameSet")
            }
        }
    }
}

#Preview {
    DataTestView()
}
