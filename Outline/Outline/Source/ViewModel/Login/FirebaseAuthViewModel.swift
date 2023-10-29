//
//  FirebaseAuthViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/28/23.
//

import SwiftUI

class FirebaseAuthViewModel: ObservableObject {
    @Published var appleAuthCoordinator: AppleAuthCoordinator?
    @Published var kakaoAuthCoordinator: KakaoAuthCoordinator?
    
    func handleAppleLogin(window: UIWindow?) {
        appleAuthCoordinator = AppleAuthCoordinator(window: window)
        appleAuthCoordinator?.startAppleLogin()
    }
    
    func handleKaKaoSignUp(){
        kakaoAuthCoordinator = KakaoAuthCoordinator()
        kakaoAuthCoordinator?.kakaoAuthSignIn()
    }

}
