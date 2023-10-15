//
//  UserModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

protocol UserModelProtocol {
    
}

enum ReadDataError: Error {
    case notFound
    case noData
}

struct UserModel: UserModelProtocol {
    private let userListRef = Firestore.firestore().collection("userList")
    
    func readUserInfo(uid: String, completion: @escaping (Result<UserInfo, ReadDataError>) -> Void) async {
        userListRef.document(uid).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, error == nil else { return }
            
            do {
                let userInfo = try snapshot.data(as: UserInfo.self)
                completion(.success(userInfo))
            } catch {
                completion(.failure(.noData))
            }
        }
    }
    
    func updateUserInfo(uid: String, nickname: String?, birthday: String?, height: String?, weight: String?, gender: Gender?) {}
    func readUserRecords() {}
    func readUserRecord(id: String) {}
    func updateOrCreateUserRecord(id: String, record: Record) {}
    func deleteUserRecord(id: String) {}
    func createUser(nickname: String?) {}
    func deleteUser(uid: String) {}
}

//struct UserModel {
//    private let userListRef = Firestore.firestore().collection("userList")
//    
//    func writeUserData(user: User) {
//        let userRef = userListRef.document(user.uid)
//        userListRef.updateData([
//            "uid": user.uid,
//            "nickname": user.nickname,
//            "height": user.height,
//            "weight": user.weight,
//            "gender": user.gender.rawValue,
//            "imageURL": "",
//            "records": [],
//            "currentRunningData": []
//        ]) { error in
//            guard let error = error else {
//                return
//            }
//            print("error")
//        }
//    }
    
//        userListRef.getDocuments { (snapshot, error) in
//            guard error == nil else {
//                print("error", error ?? "")
//                return
//            }
//            guard let snapshot = snapshot else {return}
//
//            for document in snapshot.documents {
//                let data = document.data()
//
//                let name = data["nickname"] as? String ?? ""
//                let heightTemp = data["height"] as? Int ?? 0
//                self.userList.append(User(nickname: name, height: heightTemp))
//            }
//        }
