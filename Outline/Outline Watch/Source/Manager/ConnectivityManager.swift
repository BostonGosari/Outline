//
//  ConnectivityManager.swift
//  Outline
//
//  Created by hyunjun on 8/10/24.
//

import Foundation
import WatchConnectivity

final class ConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var allCourses: [GPSArtCourse] = []
    @Published var runningState: MirroringRunningState?
    @Published var runningInfo = MirroringRunningInfo()
    @Published var runningData = MirroringRunningData()
    @Published var isMirroring = false

    static let shared = ConnectivityManager()
    let session = WCSession.default
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            print("오류: 워치 세션이 지원되지 않습니다")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("세션 활성화에 실패했습니다. 오류: \(error.localizedDescription)")
            return
        }
    }
}

// MARK: - 송신
extension ConnectivityManager {
    func sendRunningRecord(_ record: RunningRecord) {
        if let data = encodeData(from: record) {
            let userInfo = ["newRunningRecord": data]
            session.transferUserInfo(userInfo)
        }
    }

    func sendRunningState(_ runningState: MirroringRunningState) {
        if let data = encodeData(from: runningState) {
            let userInfo = ["runningState": data]
            session.transferUserInfo(userInfo)
        }
    }

    func sendIsMirroring(_ isMirroring: Bool) {
        let userInfo = ["isMirroring": isMirroring]
        session.transferUserInfo(userInfo)
    }

    func sendRunningInfo(_ runningInfo: MirroringRunningInfo) {
        if let data = encodeData(from: runningInfo) {
            let userInfo = ["runningInfo": data]
            session.transferUserInfo(userInfo)
        }
    }

    func sendRunningData(_ runningData: MirroringRunningData) {
        if let data = encodeData(from: runningData) {
            let userInfo = ["runningData": data]
            session.transferUserInfo(userInfo)
            print("러닝 데이터를 전송했습니다.")
        }
    }
    
    /// 입력받은 값을 인코딩해주는 메서드
    private func encodeData<T: Encodable>(from value: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(value)
            return encodedData
        } catch {
            print("\(T.self)을(를) 인코딩하는 데 실패했습니다: \(error)")
            return nil
        }
    }
}

// MARK: - 수신
extension ConnectivityManager {
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        /// iOS로부터 아트코스를 받는 로직
        if let data = userInfo["gpsArtCourses"] as? Data {
            if let courses = decodeData([GPSArtCourse].self, from: data) {
                self.allCourses = courses
                print("모든 코스를 수신했습니다")
            }
        }
        
        /// 미러링
        if let data = userInfo["runningState"] as? Data {
            if let runningState = decodeData(MirroringRunningState.self, from: data) {
                self.runningState = runningState
                print("러닝 상태를 수신했습니다")
            }
        }
        
        if let data = userInfo["isMirroring"] as? Bool {
            self.isMirroring = data
            print("미러링 상태를 수신했습니다: \(data)")
        }
        
        if let data = userInfo["runningInfo"] as? Data {
            if let runningInfo = decodeData(MirroringRunningInfo.self, from: data) {
                self.runningInfo = runningInfo
                print("러닝 정보를 수신했습니다")
            }
        }
        
        if let data = userInfo["runningData"] as? Data {
            if let runningData = decodeData(MirroringRunningData.self, from: data) {
                self.runningData = runningData
                print("러닝 데이터를 수신했습니다")
            }
        }
    }
    
    /// 입력받은 데이터를 디코딩해주는 메서드
    private func decodeData<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("\(T.self)을(를) 디코딩하는 데 실패했습니다: \(error)")
            return nil
        }
    }
}
