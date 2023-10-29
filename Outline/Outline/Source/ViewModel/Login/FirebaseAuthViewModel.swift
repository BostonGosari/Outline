//
//  FirebaseAuthViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/28/23.
//

import SwiftUI

class FirebaseAuthViewModel: ObservableObject {
    @Published private var appleLoginCoordinator: AppleAuthCoordinator?
    
    func handleAppleLogin(window: UIWindow?) {
        appleLoginCoordinator = AppleAuthCoordinator(window: window)
        appleLoginCoordinator?.startAppleLogin()
    }

}
