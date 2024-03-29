//
//  ProfileViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 11/2/23.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    @AppStorage("userId") var userId: String?
    @AppStorage("authState") var authState: AuthState = .logout
    
    @Published var userInfo = UserInfo(nickname: "", birthday: Date(), height: 170, weight: 60)
    
    private let userInfoModel = UserInfoModel()
    private let authModel = AuthModel()
    private let userDataModel = UserDataModel()
    
    func saveUserInfoOnDB() {
        guard let userId = userId else {
            print("fail to userInfo updated: userId is nil")
            return
        }
        userInfoModel.updateUserInfo(uid: userId, userInfo: userInfo) { result in
            switch result {
            case .success(let success):
                print("success to userInfo updated \(success)")
            case .failure(let failure):
                print("fail to userInfo updated \(failure)")
            }
        }
    }
    
    func loadUserInfo() {
        guard let userId = userId else {
            print("fail to load userInfo: userId is nil")
            return
        }
        userInfoModel.readUserInfo(uid: userId) { result in
            switch result {
            case .success(let userInfo):
                self.userInfo = userInfo
                print("success to load userInfo")
            case .failure(let failure):
                print("fail to load userInfo \(failure)")
            }
        }
    }
    
    func logOut() {
        authModel.handleLogout { result in
            switch result {
            case .success(let isSuccess):
                self.authState = .logout
                self.userId = ""
                print("success to logout \(isSuccess)")
            case .failure(let error):
                print("fail to logout \(error)")
            }
        }
    }
    
    func signOut() {
        userDataModel.deleteAllRunningRecord { result in
            switch result {
            case .success(let success):
                print("success to delete all course data \(success)")
            case .failure(let failure):
                print("fail to delete all course data \(failure)")
            }
        }
        
        if let userId = self.userId {
            self.userInfoModel.deleteUser(uid: userId) { isSuccessDeleteDBUser in
                switch isSuccessDeleteDBUser {
                case .success(let isSuccess):
                    print("success to delete user on FireStore \(isSuccess)")
                case .failure(let error):
                    print("fail to delete user on FireStore")
                    print(error)
                }
            }
        }
        self.authModel.handleSignOut { result in
            switch result {
            case .success(let success):
                print("success to sign out at authModel\(success)")
            case .failure(let failure):
                print("fail to signout at authModel \(failure)")
            }
        }
        
        self.userInfoModel.deleteUserNameSet(userName: self.userInfo.nickname) { result in
            switch result {
            case .success(let success):
                print("success to delete userNameSet on DB \(success)")
            case .failure(let failure):
                print("fail to delete userNameSet on DB \(failure)")
            }
        }
        self.userId = ""
        self.authState = .logout
        print("reset userId to empty")
    }
}
