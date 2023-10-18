//
//  DataTestView.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import SwiftUI

struct DataTestView: View {
    @ObservedObject private var firstoreManager = DataTestViewModel()
    
    @FetchRequest (
        entity: CoreRunningRecord.entity(), sortDescriptors: []
    ) var runningRecords: FetchedResults<CoreRunningRecord>
    
    private let courseId = "an3yE14Ue1xsUKlDwUZu"
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(runningRecords, id: \.id) { record in
                    Text("\(record.courseData?.coursePaths ?? [])")
                        .padding(.bottom, 20)
                        .onTapGesture {
                            firstoreManager.updateRunningRecord(record, courseData: dummyCourseData, healthData: dummyHealthData)
                        }
                }
            }
            Text("user")
                .font(.title)
            Text("nickname: \(firstoreManager.userInfo.nickname)")
            Text("weight: \(firstoreManager.userInfo.weight)")
            Text("height: \(firstoreManager.userInfo.height)")
            Text("gender: \(firstoreManager.userInfo.gender.rawValue)")
            Text("course")
                .font(.title)
            VStack {
                ScrollView {
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
                }
            }
            Spacer()
            Button {
                firstoreManager.readUserInfo(uid: firstoreManager.uid)
            } label: {
                Text("readUserInfo")
            }
            Button {
                firstoreManager.updateUserInfo(uid: firstoreManager.uid, userInfo: UserInfo(nickname: "austin", birthday: Date(), height: 120, weight: 10))
            } label: {
                Text("updatedUserInfo")
            }
            Button {
                firstoreManager.createUser(nickname: "newName")
            } label: {
                Text("createUserInfo")
            }
            Button {
                firstoreManager.deleteUser(uid: firstoreManager.uid)
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
            Button {
                firstoreManager.addRunningRecord()
            } label: {
                Text("add new Record")
            }
        }
    }
}

#Preview {
    DataTestView()
}
