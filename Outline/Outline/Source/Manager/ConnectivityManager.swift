//
//  WatchConnectivityManager.swift
//  Outline
//
//  Created by hyunjun on 10/24/23.
//

import Foundation
import WatchConnectivity

final class ConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var allCourses: [GPSArtCourse] = []
    @Published var receivedCourse: GPSArtCourse = GPSArtCourse()
    @Published var runningState: MirroringRunningState?
    @Published var runningInfo: MirroringRunningInfo = MirroringRunningInfo()
    @Published var runningData: MirroringRunningData = MirroringRunningData()
    @Published var isMirroring = false
    static let shared = ConnectivityManager()
    
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
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("error sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("error sessionDidDeactivate")
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
    
    
    func sendRunningState(_ runningState: MirroringRunningState) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(runningState)
            let userInfo = ["runningState": data]
            session.transferUserInfo(userInfo)
        } catch {
            print("Failed to encode runningState")
        }
    }
    
    func sendIsMirroring(_ isMirroring: Bool) {
        let userInfo = ["isMirroring": isMirroring]
        session.transferUserInfo(userInfo)
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
            print("send runningData")
        } catch {
            print("Failed to encode runningData")
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        DispatchQueue.main.async {
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
                    let runningState = try decoder.decode(MirroringRunningState.self, from: data)
                    self.runningState = runningState
                    print("received runningState")
                } catch {
                    print("Failed to decode runningState")
                }
            }
            
            if let data = userInfo["isMirroring"] as? Bool {
                self.isMirroring = data
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
