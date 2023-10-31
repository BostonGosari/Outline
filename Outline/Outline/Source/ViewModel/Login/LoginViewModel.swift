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
    
    func loginWithApple(window: UIWindow?) {
        // if newUser => make firestore data
        authModel.handleAppleLogin(window: window) { res in
            switch res {
            case .success(let uid):
                self.userId = uid
                self.authState = .login
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
                self.authState = .login 
            case .failure(let error):
                self.authState = .logout
                print(error)
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
