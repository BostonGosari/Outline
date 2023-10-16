//
//  DataTestViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Foundation

let userInfoDefault = UserInfo(nickname: "austin", birthday: Date(), height: 175, weight: 70)

let coordinatesDefaults = [
    Coordinate(longitude: 37, latitude: 120)
]
let recordsDefault = [
    Record(courseName: "댕댕런", runningType: .gpsArt, runningDate: Date(), startTime: Date(), endTime: Date(), runningDuration: Date(), courseLength: 5.2, runningLength: 5.0, averagePace: Date(), calorie: 300, bpm: 200, cadence: 200, coursePaths: coordinatesDefaults, heading: 30, mapScale: 1.5),
    Record(courseName: "오리런", runningType: .gpsArt, runningDate: Date(), startTime: Date(), endTime: Date(), runningDuration: Date(), courseLength: 2.2, runningLength: 2.0, averagePace: Date(), calorie: 100, bpm: 100, cadence: 100, coursePaths: coordinatesDefaults, heading: 10, mapScale: 1.1)
]
let runningDataDefault = RunningData(currentTime: 20, currentLocation: 20, paceList: [2,3], bpmList: [200, 100])
let userDataDefault = UserData(records: recordsDefault, currentRunningData: runningDataDefault)

class FirstoreManager: ObservableObject {
    @Published var user = User(userInfo: userInfoDefault, userData: userDataDefault)
    @Published var courses: AllGPSArtCourses = []
    
    let userInfoModel = UserInfoModel()
    let courseModel = CourseModel()
    
    func readUserInfo(uid: String) {
        userInfoModel.readUserInfo(uid: uid) { result in
            switch result {
            case .success(let userInfo):
                self.user = User(userInfo: userInfo, userData: self.user.userData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUserInfo(uid: String, userInfo: UserInfo) {
        userInfoModel.updateUserInfo(uid: uid, userInfo: UserInfo(nickname: "moon", birthday: Date(), height: 120, weight: 100)) { result in
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
            case .success(let isSuccess):
                print("\(isSuccess)")
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
                print(courseList)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func readCourse(id: String) {
        courseModel.readCourse(id: id) { result in
            switch result {
            case .success(let courseList):
                print(courseList)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
