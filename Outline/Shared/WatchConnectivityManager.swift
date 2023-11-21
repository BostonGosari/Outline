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

struct MirroringRunningInfo: Codable {
    var runningType: RunningType = .free
    var courseName: String = ""
    var course: [Coordinate] = []
}

struct MirroringRunningData: Codable {
    var userLocations: [Coordinate] = []
    var time: Double = 0
    var distance: Double = 0
    var kcal: Double = 0
    var pace: Double = 0
    var bpm: Double = 0
}

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var allCourses: [GPSArtCourse] = []
    @Published var receivedCourse: GPSArtCourse = GPSArtCourse()
    @Published var runningState: RunningState = .end
    @Published var runningInfo: MirroringRunningInfo = MirroringRunningInfo()
    @Published var runningData: MirroringRunningData = MirroringRunningData()
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
    
    func sendRunningState(_ runningState: RunningState) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(runningState)
            let userInfo = ["runningState": data]
            session.transferUserInfo(userInfo)
        } catch {
            print("Failed to encode runningState")
        }
    }
    
    func sendRunningInfo(_ runningInfo: MirroringRunningInfo) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(runningInfo)
            let userInfo = ["runningInfo": data]
            session.transferUserInfo(userInfo)
        } catch {
            print("Failed to encode runningInfo")
        }
    }
    
    func sendRunningData(_ runningData: MirroringRunningData) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(runningData)
            let userInfo = ["runningData": data]
            session.transferUserInfo(userInfo)
        } catch {
            print("Failed to encode runningData")
        }
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
            
            // Mirroring
            if let data = userInfo["runningState"] as? Data {
                let decoder = JSONDecoder()
                do {
                    let runningState = try decoder.decode(RunningState.self, from: data)
                    self.runningState = runningState
                    print("received runningState")
                } catch {
                    print("Failed to decode runningState")
                }
            }
            
            if let data = userInfo["runningInfo"] as? Data {
                let decoder = JSONDecoder()
                do {
                    let runningInfo = try decoder.decode(MirroringRunningInfo.self, from: data)
                    self.runningInfo = runningInfo
                    print("received runningInfo")
                } catch {
                    print("Failed to decode runningInfo")
                }
            }
            
            if let data = userInfo["runningData"] as? Data {
                let decoder = JSONDecoder()
                do {
                    let runningData = try decoder.decode(MirroringRunningData.self, from: data)
                    self.runningData = runningData
                    print("received runningData")
                } catch {
                    print("Failed to decode runningData")
                }
            }
        }
    }
}
