//
//  WatchConnectivityManager.swift
//  Outline
//
//  Modified by hyunjun on 8/10/24.
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
            print("오류: 워치 세션이 지원되지 않습니다")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("세션 활성화에 실패했습니다. 오류: \(error.localizedDescription)")
            return
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("세션이 비활성화되었습니다.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("세션이 비활성화되었습니다.")
    }
    
    /// MARK: - 송신
    func sendGPSArtCourses(_ courses: [GPSArtCourse]) {
        if let data = encodeData(from: courses) {
            let userInfo = ["gpsArtCourses": data]
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
    
    /// MARK: - 수신
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        /// 워치로부터 새로운 러닝 레코드를 받아 저장합니다.
        if let data = userInfo["newRunningRecord"] as? Data {
            if let newRunningRecord = decodeData(RunningRecord.self, from: data) {
                userDataModel.createRunningRecord(record: newRunningRecord) { result in
                    switch result {
                    case .success: print("성공적으로 저장되었습니다.")
                    case .failure: print("저장에 실패했습니다.")
                    }
                }
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
