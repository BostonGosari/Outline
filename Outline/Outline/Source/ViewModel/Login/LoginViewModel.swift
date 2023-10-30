//
//  LoginViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/29/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @State var userId: String?
    private let authModel = AuthModel()
    
    func loginWithApple(window: UIWindow?) {
        authModel.handleAppleLogin(window: window) { res in
            switch res {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loginWithKakao() {
        authModel.handleKakaoSignUp { res in
            switch res {
            case .success(let uid):
                print("login success", uid )
            case .failure(let error):
                print("login failed")
                print(error.localizedDescription)
            }
        }
    }
    
    func logOut() {
        authModel.handleLogout { res in
            switch res {
            case .success(let isSuccess):
                print(isSuccess ? "logout success" : "logout failed")
            case .failure(let error):
                print("logout failed")
                print(error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        authModel.handleSignOut { res in
            switch res {
            case .success(let isSuccess):
                print(isSuccess ? "signout success" : "signout failed")
            case .failure(let error):
                print("signout failed")
                print(error.localizedDescription)
            }
        }
    }
    
    func setLoginState() {
        authModel.handleCheckLoginState { res in
            switch res {
            case .success(let uid):
                self.userId = uid
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
