//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    @StateObject private var firstoreManager = FirstoreManager()
    
    private let uid = "9CB37801-A45F-4260-94D6-D9DC1853E4AB"
    private let courseId = "an3yE14Ue1xsUKlDwUZu"
    
    var body: some View {
        VStack {
            Text("user")
                .font(.title)
            Text("nickname: \(firstoreManager.user.userInfo.nickname)")
            Text("weight: \(firstoreManager.user.userInfo.weight)")
            Text("height: \(firstoreManager.user.userInfo.height)")
            Text("gender: \(firstoreManager.user.userInfo.gender.rawValue)")
            Text("course")
                .font(.title)
            ForEach(firstoreManager.courses, id: \.id) { course in
                Text("courseName: \(course.courseName)")
                Text("courseDuration: \(course.courseDuration)")
                Text("courseLength: \(course.courseLength)")
                Text("distance: \(course.distance)")
                Text("heading: \(course.heading)")
                Text("mapScale: \(course.mapScale)")
                Text("alley: \(course.alley.rawValue)")
                Text("centerLocation: \(course.centerLocation.latitude), \(course.centerLocation.longitude), ")
                Text("level: \(course.level.rawValue)")
                Text("thumanail: \(course.thumbnail)")
            }
            Spacer()
            Button {
                firstoreManager.readUserInfo(uid: uid)
            } label: {
                Text("readUserInfo")
            }
            Button {
                firstoreManager.updateUserInfo(uid: uid, userInfo: UserInfo(nickname: "austin", birthday: Date(), height: 120, weight: 10))
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
                firstoreManager.readCourse(id: courseId)
            } label: {
                Text("readAllCourses")
            }
        }
    }
}

#Preview {
    DataTestView()
}
