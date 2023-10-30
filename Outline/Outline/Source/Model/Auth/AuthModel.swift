//
//  FirebaseAuthViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/28/23.
//

import FirebaseAuth
import SwiftUI

enum AuthError: Error {
    case userNotFound
    case userAlreadySignOut
    case errorInSignOut
    case failToDeleteUser
    case failToLogin
    case failToLoadUser
    case failToFindUserId
}

protocol AuthModelProtocol {
    func handleAppleLogin(window: UIWindow?, completion: @escaping (Result<String, AuthError>) -> Void)
    func handleKakaoSignUp(completion: @escaping (Result<String, AuthError>) -> Void)
    func handleCheckLoginState(completion: @escaping (Result<String?, AuthError>) -> Void)
    func handleLogout(completion: @escaping (Result<Bool, AuthError>) -> Void)
    func handleSignOut(completion: @escaping (Result<Bool, AuthError>) -> Void)
}

class AuthModel: AuthModelProtocol {
    private var appleAuthCoordinator: AppleAuthModel?
    private var kakaoAuthCoordinator: KakaoAuthModel?
    
    func handleAppleLogin(window: UIWindow?, completion: @escaping (Result<String, AuthError>) -> Void) {
        appleAuthCoordinator = AppleAuthModel(window: window)
        appleAuthCoordinator?.startAppleLogin()
    }
    
    func handleKakaoSignUp(completion: @escaping (Result<String, AuthError>) -> Void) {
        kakaoAuthCoordinator = KakaoAuthModel()
        kakaoAuthCoordinator?.kakaoAuthSignIn(completion: { res in
            switch res {
            case .success(let uid):
                completion(.success(uid))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func handleCheckLoginState(completion: @escaping (Result<String?, AuthError>) -> Void){
        completion(.success(Auth.auth().currentUser?.uid))
    }
    
    func handleLogout(completion: @escaping (Result<Bool, AuthError>) -> Void) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                completion(.success(true))
            } catch {
                completion(.failure(.errorInSignOut))
            }
        } else {
            completion(.failure(.userAlreadySignOut))
        }
    }
    
    func handleSignOut(completion: @escaping (Result<Bool, AuthError>) -> Void) {
        let user = Auth.auth().currentUser
        if let user = user {
            user.delete { error in
              if let _ = error {
                completion(.failure(.errorInSignOut))
              } else {
                  completion(.success(true))
              }
            }
        } else {
            completion(.failure(.failToDeleteUser))
        }
    }
}
