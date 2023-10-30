//
//  LoginViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/29/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var userId: String?
    @AppStorage("authState") var authState: AuthState = .onboarding
    
    private let authModel = AuthModel()
    
    func loginWithApple(window: UIWindow?) {
        authModel.handleAppleLogin(window: window) { res in
            switch res {
            case .success(let uid):
                self.userId = uid
                self.authState = .login
            case .failure(_):
                self.authState = .logout
            }
        }
    }
    
    func loginWithKakao() {
        authModel.handleKakaoSignUp { res in
            switch res {
            case .success(let uid):
                self.userId = uid
                self.authState = .login
            case .failure(_):
                self.authState = .logout
            }
        }
    }
    
    func logOut() {
        authModel.handleLogout { res in
            switch res {
            case .success(_):
                self.authState = .logout
                self.userId = ""
            case .failure(_):
                print("logout failed")
            }
        }
    }
    
    func signOut() {
        authModel.handleSignOut { res in
            switch res {
            case .success(_):
                self.authState = .logout
                self.userId = ""
            case .failure(_):
                print("signout failed")
            }
        }
    }
    
    func setLoginState() {
        authModel.handleCheckLoginState { res in
            switch res {
            case .success(let uid):
                self.userId = uid
                self.authState = .login
            case .failure(_):
                print("user not found")
                self.authState = .logout
            }
        }
    }
}
