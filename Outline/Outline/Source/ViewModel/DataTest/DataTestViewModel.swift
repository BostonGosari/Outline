//
//  DataTestViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Foundation
import CoreLocation
import SwiftUI

let userInfoDummy = UserInfo(nickname: "austin", birthday: Date(), height: 175, weight: 70)

class DataTestViewModel: ObservableObject {
    @Published var userInfo: UserInfo = userInfoDummy
    @Published var courses: AllGPSArtCourses = []
    @Published var uid = ""
    
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
        userDataModel.createRunningRecord(record: newRunningRecord)
    }
    func addCoordinate() {
        let newCoordinate = CLLocationCoordinate2D(latitude: 32.0, longitude: 154.0)
        userDataModel.createCoordinate(coordinate: newCoordinate)
    }
}

let dummyCourseData = CourseData(courseName: "오리런", runningDate: Date(), startTime: Date(), endTime: Date(), heading: 1.4, distance: 200, coursePathes: [
    CLLocationCoordinate2D(latitude: 26, longitude: 152),
    CLLocationCoordinate2D(latitude: 16, longitude: 122)
], courseLength: 5
)
let dummyHealthData = HealthData(totalTime: "40", averageCyclingCadence: "20", totalRunningDistance: "5", totalEnergy: "500", averageHeartRate: "150", averagePace: "5")
