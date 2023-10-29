//
//  FirebaseAuthViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/28/23.
//

import FirebaseAuth
import SwiftUI

class AuthModel{
    private var appleAuthCoordinator: AppleAuthModel?
    private var kakaoAuthCoordinator: KakaoAuthModel?
    
    func handleAppleLogin(window: UIWindow?) {
        appleAuthCoordinator = AppleAuthModel(window: window)
        appleAuthCoordinator?.startAppleLogin()
    }
    
    func handleKakaoSignUp() {
        kakaoAuthCoordinator = KakaoAuthModel()
        kakaoAuthCoordinator?.kakaoAuthSignIn()
    }
    
    func handleCheckLoginState() -> String? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser?.uid
        } else {
            return nil
        }
    }
    
    func handleLogout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                print("error in sign out")
            }
        } else {
            print("already sign out")
        }
    }
    
    func handleSignOut() {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            print("유저 삭제 실패")
          } else {
            print("유저 삭제 완료")
          }
        }
    }
}
