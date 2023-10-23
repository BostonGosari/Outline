//
//  WatchConnectivityManager.swift
//  Outline
//
//  Created by hyunjun on 10/24/23.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {

    @Published var allCourses: [GPSArtCourse] = []
    
    static let shared = WatchConnectivityManager()
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
    func sessionDidBecomeInactive(_ session: WCSession) { }

    func sessionDidDeactivate(_ session: WCSession) { }
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

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        DispatchQueue.main.async {
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
        }
    }
}
