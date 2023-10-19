//
//  UserModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

protocol UserInfoModelProtocol {
    func readUserInfo(uid: String, completion: @escaping (Result<UserInfo, ReadDataError>) -> Void)
    func updateUserInfo(uid: String, userInfo: UserInfo, completion: @escaping (Result<Bool, ReadDataError>) -> Void)
    func createUser(nickname: String?, completion: @escaping (Result<String, ReadDataError>) -> Void)
    func deleteUser(uid: String, completion: @escaping (Result<Bool, ReadDataError>) -> Void)
}

enum ReadDataError: Error {
    case dataNotFound
    case typeError
}

struct UserInfoModel: UserInfoModelProtocol {
    
    private let userListRef = Firestore.firestore().collection("userList")
    private let userUtilRef = Firestore.firestore().collection("util")
    
    func readUserInfo(uid: String, completion: @escaping (Result<UserInfo, ReadDataError>) -> Void) {
        userListRef.document(uid).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let userInfo = try snapshot.data(as: UserInfo.self)
                completion(.success(userInfo))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
    
    func updateUserInfo(uid: String, userInfo: UserInfo, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        do {
            try userListRef.document(uid).setData(from: userInfo)
            completion(.success(true))
        } catch {
            completion(.failure(.typeError))
        }
    }
    
    func createUser(nickname: String?, completion: @escaping (Result<String, ReadDataError>) -> Void) {
        let newUserInfo = UserInfo(nickname: nickname ?? "default", birthday: Date(), height: 175, weight: 70)
        let uid = UUID().uuidString
        
        do {
            try userListRef.document(uid).setData(from: newUserInfo)
            completion(.success(uid))
        } catch {
            completion(.failure(.typeError))
        }
    }
    
    func deleteUser(uid: String, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        userListRef.document(uid).delete()
        completion(.success(true))
    }
    
    func readUserNameSet(completion: @escaping (Result<[String], ReadDataError>) -> Void) {
        userUtilRef.document("userNameSet").getDocument { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            do {
                let userNameSet = try snapshot.data(as: UserNameSet.self)
                completion(.success(userNameSet.userNames))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
    
    func updateUserNameSet(newUserNames: [String], completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        if newUserNames.isEmpty {
            completion(.failure(.dataNotFound))
        }
        do {
            try userUtilRef.document("userNameSet").setData(from: UserNameSet(userNames: newUserNames))
            completion(.success(true))
        } catch {
            completion(.failure(.typeError))
        }
    }
}
