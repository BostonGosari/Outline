//
//  WatchConnectivityManager.swift
//  Outline
//
//  Created by hyunjun on 10/24/23.
//

import Foundation
import WatchConnectivity

enum RunningState: Codable {
    case start
    case pause
    case resume
    case end
}

struct MirroringModel: Codable {
    var runningType: RunningType
    var courseName: String
    var course: [Coordinate]
    var userLocations: [Coordinate]
    var time: Double
    var distance: Double
    var kcal: Double
    var pace: Double
}

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var allCourses: [GPSArtCourse] = []
    @Published var receivedCourse: GPSArtCourse = GPSArtCourse()
    @Published var runningState: RunningState = .end
    static let shared = WatchConnectivityManager()
    
    private let userDataModel = UserDataModel()
    let session = WCSession.default
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            print("ERROR: Watch session not supported")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("error sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) { 
        print("error sessionDidDeactivate")
    }
#endif
    
    func sendGPSArtCourse(_ course: GPSArtCourse) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(course)
            let userInfo = ["gpsArtCourse": data]
            session.transferUserInfo(userInfo)
        } catch {
            print("Failed to encod GPSArtCourse")
        }
    }
    
    func sendGPSArtCoursesToWatch(_ courses: [GPSArtCourse]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(courses)
            let userInfo = ["gpsArtCourses": data]
            session.transferUserInfo(userInfo)
        } catch {
            print("Failed to encode GPSArtCourses: \(error)")
        }
    }
    
    func sendRunningRecordToPhone(_ record: RunningRecord) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(record)
            let userInfo = ["newRunningRecord": data]
            session.transferUserInfo(userInfo)
        } catch {
            print("Failed to encode RunningReecord")
        }
    }
    
    func sendRunning(_ runningState: RunningState) {
        let runningState = ["runningState": runningState]
        session.transferUserInfo(runningState)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        DispatchQueue.main.async {
            // watchOS
            if let data = userInfo["gpsArtCourses"] as? Data {
                let decoder = JSONDecoder()
                do {
                    let courses = try decoder.decode([GPSArtCourse].self, from: data)
                    self.allCourses = courses
                    print("received all courses")
                } catch {
                    print("Failed to decode GPSArtCourses: \(error)")
                }
            }
            
            if let data = userInfo["gpsArtCourse"] as? Data {
                let decoder = JSONDecoder()
                do {
                    let course = try decoder.decode(GPSArtCourse.self, from: data)
                    self.receivedCourse = course
                    print("received course")
                } catch {
                    print("Failed to decode GPSArtCourse: \(error)")
                }
            }
            
            if let runningState = userInfo["runningState"] as? RunningState {
                self.runningState = runningState
            }
            
            // iOS
            if let data = userInfo["newRunningRecord"] as? Data {
                let decoder = JSONDecoder()
                do {
                    let newRunningRecord = try decoder.decode(RunningRecord.self, from: data)
                    self.userDataModel.createRunningRecord(record: newRunningRecord) { result in
                        switch result {
                        case .success:
                            print("saved")
                        case .failure:
                            print("fail to save")
                        }
                    }
                } catch {
                    
                }
            }
        }
    }
}
