//
//  ProfileViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 11/2/23.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    @AppStorage("userId") var userId: String?
    @AppStorage("authState") var authState: AuthState = .onboarding
    
    @Published var userInfo = UserInfo(nickname: "", birthday: Date(), height: 170, weight: 60)
    
    private let userInfoModel = UserInfoModel()
    private let authModel = AuthModel()
    private let userDataModel = UserDataModel()
    
    func saveUserInfoOnDB() {
        guard let userId = userId else {
            print("fail to userInfo updated: userId is nil")
            return
        }
        userInfoModel.updateUserInfo(uid: userId, userInfo: userInfo) { res in
            switch res {
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
        userInfoModel.readUserInfo(uid: userId) { res in
            switch res {
            case .success(let userInfo):
                self.userInfo = userInfo
                print("success to load userInfo")
            case .failure(let failure):
                print("fail to load userInfo")
            }
        }
    }
    
    func logOut() {
        authModel.handleLogout { res in
            switch res {
            case .success(let isSuccess):
                self.authState = .logout
                self.userId = ""
                print("success to logout \(isSuccess)")
            case .failure(let error):
                print("fail to logout")
                print(error)
            }
        }
    }
    
    func signOut() {
        // Delete FireStoreData, CoreData
        authModel.handleSignOut { res in
            switch res {
            case .success(let isSuccess):
                self.authState = .logout
                
                if let userId = self.userId {
                    self.userInfoModel.deleteUser(uid: userId) { isSuccessDeleteDBUser in
                        switch isSuccessDeleteDBUser {
                        case .success(let success):
                            print("success to delete user on FireStore \(success)")
                        case .failure(let failure):
                            print("fail to delete user on FireStore")
                            print("\(failure)")
                        }
                    }
                    self.userDataModel.deleteAllRunningRecord { res in
                        switch res {
                        case .success(let success):
                            print("success to delete all running data \(success)")
                        case .failure(let failure):
                            print("fail to delete all running data \(failure)")
                        }
                    }
                }
                self.userId = ""
                print("reset userId to empty \(isSuccess)")
            case .failure(let error):
                print("fail to signout")
                print(error)
            }
        }
    }
}
