//
//  DataTestViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Foundation

let userInfoDummy = UserInfo(nickname: "austin", birthday: Date(), height: 175, weight: 70)

//let coordinatesDummy = [
//    Coordinate(longitude: 37, latitude: 120)
//]
//let recordsDummy = [
//    Record(courseName: "댕댕런", runningType: .gpsArt, runningDate: Date(), startTime: Date(), endTime: Date(), runningDuration: Date(), courseLength: 5.2, runningLength: 5.0, averagePace: Date(), calorie: 300, bpm: 200, cadence: 200, coursePaths: coordinatesDummy, heading: 30, mapScale: 1.5),
//    Record(courseName: "오리런", runningType: .gpsArt, runningDate: Date(), startTime: Date(), endTime: Date(), runningDuration: Date(), courseLength: 2.2, runningLength: 2.0, averagePace: Date(), calorie: 100, bpm: 100, cadence: 100, coursePaths: coordinatesDummy, heading: 10, mapScale: 1.1)
//]
//let runningDataDummy = RunningData(currentTime: 20, currentLocation: 20, paceList: [2, 3], bpmList: [200, 100])
//let userDataDummy = UserData(records: recordsDummy, currentRunningData: runningDataDummy)

class FirstoreManager: ObservableObject {
    @Published var userInfo: UserInfo = userInfoDummy
    @Published var courses: AllGPSArtCourses = []
    @Published var uid = ""
    
    let userInfoModel = UserInfoModel()
    let courseModel = CourseModel()
    
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
                print(courseList)
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
}
