//
//  FirebaseAuthViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/28/23.
//

import AuthenticationServices
import CryptoKit
import SwiftUI


class FirebaseAuthViewModel: ObservableObject {
    
}

class AppleAuthCoordinator: NSObject{
    var currentNonce: String?
    
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
        let charset: Array<Character> =
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
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
              idToken: idTokenString,
              rawNonce: nonce)

          //Firebase 작업
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if error {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
              print(error.localizedDescription)
              return
            }
            // User is signed in to Firebase with Apple.
            // ...
          }
        }
      }
}
