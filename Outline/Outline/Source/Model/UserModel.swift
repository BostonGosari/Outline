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
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let userInfo = try snapshot.data(as: UserInfo.self)
                completion(.success(userInfo))
            } catch {
                completion(.failure(.noData))
            }
        }
    }
    
    func updateUserInfo(uid: String, userInfo: UserInfo, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        do {
            try userListRef.document(uid).setData(from: userInfo)
            completion(.success(true))
        } catch {
            completion(.failure(.noData))
        }
    }
    
    func createUser(nickname: String?, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        let newUserInfo = UserInfo(nickname: nickname ?? "default", birthday: Date(), height: 175, weight: 70)
        
        do {
            try userListRef.document(UUID().uuidString).setData(from: newUserInfo)
            completion(.success(true))
        } catch {
            completion(.failure(.noData))
        }
    }
    func deleteUser(uid: String) {}
    
    func readUserRecords() {}
    func readUserRecord(id: String) {}
    func updateOrCreateUserRecord(id: String, record: Record) {}
    func deleteUserRecord(id: String) {}
}
