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
        authModel.handleAppleLogin(window: window)
    }
    
    func loginWithKakao() {
        authModel.handleKakaoSignUp()
    }
    
    func logOut() {
        authModel.handleLogout()
    }
    
    func signOut() {
    }
    
    func setLoginState() {
        guard let uid = authModel.handleCheckLoginState() else {
            print("logout or user not created")
            return
        }
        self.userId = uid
    }
}
