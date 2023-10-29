//
//  KakaoLoginCoordinator.swift
//  Outline
//
//  Created by Seungui Moon on 10/29/23.
//

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SwiftUI

class KakaoAuthModel: NSObject {
    func kakaoAuthSignIn() {
        if AuthApi.hasToken() { // 발급된 토큰이 있는지
            UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
                    print(error.localizedDescription)
                    self.openKakaoService()
                } else { // 유효한 토큰
                    self.loadingInfoDidKakaoAuth()
                }
            }
        } else { // 만료된 토큰
            print("토큰 만료됨")
            self.openKakaoService()
        }
    }
    
    private func openKakaoService() {
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                
                _ = oauthToken // 로그인 성공
                
                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        } else { // 카카오톡 앱 이용 불가능한 사람
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                _ = oauthToken // 로그인 성공
                
                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        }
    }
    
    private func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                return
            }
            guard let email = kakaoUser?.kakaoAccount?.email else { return }
            guard let password = kakaoUser?.id else { return }
            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
            
            self.emailAuthSignUp(email: email, userName: userName, password: "\(password)") {
                print("kakaologin success")
            }
        }
    }
    
    private func emailAuthSignUp(
        email: String,
        userName: String,
        password: String,
        completion: (() -> Void)?
    ) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.emailAuthSignIn(email: email, password: password) {
                    print("login success")
                }
            }
            if result != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                print(result?.user.uid ?? "")
            }
            completion?()
        }
    }
    
    private func emailAuthSignIn(
        email: String,
        password: String,
        completion: (() -> Void)?
    ){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let error = error else {
                print(error?.localizedDescription ?? "kakao signIn error")
                return
            }
            guard let authResult = authResult else {
                print("kakao signIn authResult not Found")
                return
            }
            print("login success")
            print(authResult.user.uid)
        }
    }
}
