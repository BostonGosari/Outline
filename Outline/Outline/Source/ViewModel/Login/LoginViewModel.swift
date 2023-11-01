//
//  LoginViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/29/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @AppStorage("userId") var userId: String?
    @AppStorage("authState") var authState: AuthState = .onboarding
    
    private let authModel = AuthModel()
    private let userDataModel = UserDataModel()
    private let userInfoModel = UserInfoModel()
    
    func loginWithApple(window: UIWindow?) {
        // if newUser => make firestore data
        authModel.handleAppleLogin(window: window) { res in
            switch res {
            case .success(let uid):
                self.userId = uid
                self.checkLoginOrSignIn(uid: uid)
            case .failure(let error):
                self.authState = .logout
                print(error)
            }
        }
    }
    
    func loginWithKakao() {
        // if newUser => make firestore data
        authModel.handleKakaoSignUp { res in
            switch res {
            case .success(let uid):
                self.userId = uid
                self.checkLoginOrSignIn(uid: uid)
            case .failure(let error):
                self.authState = .logout
                print(error)
            }
        }
    }
    
    func checkLoginOrSignIn(uid: String){
        userInfoModel.readUserInfo(uid: uid) { res in
            switch res {
            case .success(let userInfo):
                print(userInfo)
                print("user already exist")
                self.authState = .login
            case .failure(_):
                print("newUser")
                self.authState = .onboarding
                self.setNewUser(uid: uid)
            }
        }
    }
    func setNewUser(uid: String){
        userInfoModel.createUser(uid: uid, nickname: "default") { res in
            switch res {
            case .success(_):
                print("success to create user")
            case .failure(_):
                print("fail to create user")
            }
        }
    }
    
    func logOut() {
        authModel.handleLogout { res in
            switch res {
            case .success(let isSuccess):
                self.authState = .logout
                self.userId = ""
                print(isSuccess)
            case .failure(let error):
                print("logout failed")
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
                            print(success ? "delete user on FireStore" : "")
                        case .failure(let failure):
                            print("\(failure)")
                        }
                    }
                }
                self.userId = ""
                print(isSuccess)
            case .failure(let error):
                print("signout failed")
                print(error)
            }
        }
    }
    
    func setLoginState() {
        authModel.handleCheckLoginState { res in
            switch res {
            case .success(let uid):
                self.userId = uid
                self.authState = .login
            case .failure(let error):
                print("user not found")
                self.authState = .logout
                print(error)
            }
        }
    }
}
