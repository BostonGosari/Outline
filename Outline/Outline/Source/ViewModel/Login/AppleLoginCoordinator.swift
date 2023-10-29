//
//  AppleLoginCoordinator.swift
//  Outline
//
//  Created by Seungui Moon on 10/28/23.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import SwiftUI

class AppleAuthCoordinator: NSObject{
    
    var currentNonce: String?
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func startAppleLogin() {
        // nonce는 매번 로그인을 요청할 때마다 새롭게 만들어내 Firebase에서 받는 nonce 값과, Apple에서 제공하는 값을 비교하기 용이하게 한다.
        // request 구현
        let nonce = randomNonceString()
        currentNonce = nonce
        //
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        // request 요청
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        // 로그인 버튼을 눌렀을 때 창이 어디 떠야하는지
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Firebase 제공 코드
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Firebase 제공 코드
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
         let randoms: [UInt8] = (0 ..< 16).map { _ in
           var random: UInt8 = 0
           let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
           if errorCode != errSecSuccess {
             fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
           }
           return random
         }

         randoms.forEach { random in
           if remainingLength == 0 {
             return
           }

           if random < charset.count {
             result.append(charset[Int(random)])
             remainingLength -= 1
           }
         }
       }

       return result
    }
}

extension AppleAuthCoordinator: ASAuthorizationControllerDelegate {
    
    // 로그인 진행 및 결과 handling
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            // Initialize a Firebase credential.
            // credential은 FirebaseAuth를 사용할 때 토큰 등의 정보를 전달하기 위해서 만드는 것으로, 하단에서 볼 수 있는 Auth.auth().signIn(with: credential) 에서 사용하고 있다.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
              idToken: idTokenString,
              rawNonce: nonce)

            print(credential)
            
            //Firebase 작업
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // authResult?.user.uid을 key 값으로 데이터 저장
                if let userId = authResult?.user.uid {
                    // handle userId
                } else {
                    // login failed
                }
            }
        }
    }
}

extension AppleAuthCoordinator: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        window!
    }
}

struct WindowKey: EnvironmentKey {
  struct Value {
    weak var value: UIWindow?
  }

  static let defaultValue: Value = .init(value: nil)
}

extension EnvironmentValues {
  var window: UIWindow? {
    get {
      return self[WindowKey.self].value
    }
    set {
      self[WindowKey.self] = .init(value: newValue)
    }
  }
}
