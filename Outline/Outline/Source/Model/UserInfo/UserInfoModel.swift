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
    func createUser(uid: String, nickname: String?, completion: @escaping (Result<Bool, ReadDataError>) -> Void)
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
    
    func createUser(uid: String = UUID().uuidString, nickname: String?, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        let newUserInfo = UserInfo(nickname: nickname ?? "default", birthday: Date(), height: 175, weight: 70)
        let uid = uid
        
        do {
            try userListRef.document(uid).setData(from: newUserInfo)
            completion(.success(true))
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
    
    func updateUserNameSet(oldUserName: String, newUserName: String, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        readUserNameSet { readUserNameResult in
            switch readUserNameResult {
            case .success(let userNameList):
                do {
                    let newUserNameList = userNameList.map { userName in
                        if userName == oldUserName {
                            return newUserName
                        }
                        return userName
                    }
                    try userUtilRef.document("userNameSet").setData(from: UserNameSet(userNames: newUserNameList))
                    completion(.success(true))
                } catch {
                    completion(.failure(.typeError))
                }
            case .failure(let failure):
                completion(.failure(.dataNotFound))
            }
        }
    }
    
    func createUserNameSet(userName: String, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        readUserNameSet { readUserNameResult in
            switch readUserNameResult {
            case .success(let userNameList):
                do {
                    var newUserNameList = userNameList
                    newUserNameList.append(userName)
                    try userUtilRef.document("userNameSet").setData(from: UserNameSet(userNames: newUserNameList))
                    completion(.success(true))
                } catch {
                    completion(.failure(.typeError))
                }
            case .failure(let failure):
                completion(.failure(.dataNotFound))
            }
        }
    }
    
    func deleteUserNameSet(userName: String, completion: @escaping (Result<Bool, ReadDataError>) -> Void) {
        readUserNameSet { readUserNameResult in
            switch readUserNameResult {
            case .success(let userNameList):
                do {
                    try userUtilRef
                        .document("userNameSet")
                        .setData(from: UserNameSet(userNames: userNameList.filter({ $0 != userName })))
                    completion(.success(true))
                } catch {
                    completion(.failure(.typeError))
                }
            case .failure(let failure):
                completion(.failure(.dataNotFound))
            }
        }
    }
}
