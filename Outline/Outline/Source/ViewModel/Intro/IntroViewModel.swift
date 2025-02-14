//
//  IntroViewModel.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/14/25.
//

import SwiftUI

class IntroViewModel: ObservableObject {
    @AppStorage("userId") var userId: String?
    @AppStorage("authState") var authState: AuthState = .logout

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
                print("success to login on Apple")
            case .failure(let error):
                self.authState = .logout
                print(error)
                print("fail to login on kakao")
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
                print("success to login on kakao")
            case .failure(let error):
                self.authState = .logout
                print(error)
                print("fail to login on kakao")
            }
        }
    }

    func checkLoginOrSignIn(uid: String) {
        userInfoModel.readUserInfo(uid: uid) { res in
            switch res {
            case .success(let userInfo):
                print(userInfo)
                print("user already exist")
                // TODO: call createUserName()
                self.authState = .login
            case .failure:
                print("newUser")
                self.authState = .onboarding
                self.setNewUser(uid: uid)
            }
        }
    }

    func setNewUser(uid: String) {
        userInfoModel.createUser(uid: uid, nickname: "default") { res in
            switch res {
            case .success(let isSuccess):
                print("success to create user \(isSuccess)")
            case .failure(let error):
                print("fail to create user")
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
