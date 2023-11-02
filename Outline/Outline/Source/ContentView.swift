//
//  ContentView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import SwiftUI

enum AuthState: String {
    case onboarding
    case logout
    case login
    case lookAround
}

struct ContentView: View {
    @AppStorage("userId") var userId: String?
    @AppStorage("authState") var authState: AuthState = .logout
    
    var body: some View {
        Group {
            switch authState {
            case .onboarding:
                InputNicknameView()
            case .logout:
                LoginView()
            case .lookAround:
                HomeTabView()
            case .login:
                HomeTabView()
            }
        }
        .onAppear {
            AuthModel().handleCheckLoginState { res in
                switch res {
                case .success(let userId):
                    if let userId = userId {
                        self.userId = userId
                        self.authState = .login
                    } else {
                        if self.authState != .lookAround {
                            self.authState = .logout
                        }
                    }
                case .failure(let failure):
                    if self.authState != .lookAround {
                        self.authState = .logout
                    }
                    print("fail to find userInfo \(failure)")
                }
            }
        }
        .tint(.customPrimary)
    }
}

#Preview {
    ContentView()
}
