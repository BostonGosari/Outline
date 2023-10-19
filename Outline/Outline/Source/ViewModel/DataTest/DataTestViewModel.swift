//
//  DataTestViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Foundation
import CoreLocation
import CoreData
import SwiftUI

let userInfoDummy = UserInfo(nickname: "austin", birthday: Date(), height: 175, weight: 70)
let dummyCourseData = CourseData(courseName: "댕댕런", runningLength: 5, heading: 1.3, distance: 400, coursePaths: [
    CLLocationCoordinate2D(latitude: 26, longitude: 152),
    CLLocationCoordinate2D(latitude: 16, longitude: 122)
])
let dummyHealthData = HealthData(totalTime: 40, averageCadence: 20, totalRunningDistance: 50, totalEnergy: 200, averageHeartRate: 150, averagePace: 5, startDate: Date(), endDate: Date())

class DataTestViewModel: ObservableObject {
    
    @Published var userInfo: UserInfo = userInfoDummy
    @Published var courses: AllGPSArtCourses = []
    @Published var uid = ""
    
    var userNameSet: [String] = []
    let userInfoModel = UserInfoModel()
    let courseModel = CourseModel()
    let userDataModel = UserDataModel()
    
    func readUserInfo(uid: String) {
        userInfoModel.readUserInfo(uid: uid) { result in
            switch result {
            case .success(let userInfo):
                self.userInfo = userInfo
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUserInfo(uid: String, userInfo: UserInfo) {
        userInfoModel.updateUserInfo(uid: uid, userInfo: userInfo) { result in
            switch result {
            case .success(let isSuccess):
                print("\(isSuccess)")
            case .failure(let error):
                print(error)
            }
            self.readUserInfo(uid: uid)
        }
    }
    
    func createUser(nickname: String = "") {
        userInfoModel.createUser(nickname: "austin") { result in
            switch result {
            case .success(let uid):
                self.uid = uid
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteUser(uid: String) {
        userInfoModel.deleteUser(uid: uid) { result in
            switch result {
            case .success(let isSuccess):
                print("\(isSuccess)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func readAllCourses() {
        courseModel.readAllCourses { result in
            switch result {
            case .success(let courseList):
                self.courses = courseList
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func readCourse(id: String) {
        courseModel.readCourse(id: id) { result in
            switch result {
            case .success(let course):
                self.courses.append(course)
                print(course)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addRunningRecord() {
        let newRunningRecord = RunningRecord(id: UUID().uuidString, runningType: .free, courseData: dummyCourseData, healthData: dummyHealthData)
        userDataModel.createRunningRecord(record: newRunningRecord) { result in
            switch result {
            case .success(let isSaved):
                print(isSaved)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateRunningRecord(_ record: NSManagedObject, courseName: String) {
        userDataModel.updateRunningRecordCourseName(record, newCourseName: courseName) { result in
            switch result {
            case .success(let isSaved):
                print(isSaved)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteRunningRecord(_ record: NSManagedObject) {
        userDataModel.deleteRunningRecord(record) { result in
            switch result {
            case .success(let isSaved):
                print(isSaved)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func readUserNameSet() {
        userInfoModel.readUserNameSet { result in
            switch result {
            case .success(let userList):
                self.userNameSet = userList
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUserNameSet(userNameFrom: String, userNameTo: String) {
        self.readUserNameSet()
        if !self.userNameSet.contains(userNameFrom) {
            print("nickname error")
            return
        }
        var newUserList = self.userNameSet.filter({ $0 != userNameFrom })
        newUserList.append(userNameTo)
        userInfoModel.updateUserNameSet(newUserNames: newUserList) { result in
            switch result {
            case .success(let isSaved):
                print(isSaved)
            case .failure(let error):
                print(error)
            }
        }
    }
}
