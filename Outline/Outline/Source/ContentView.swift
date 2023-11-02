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
        .tint(.customPrimary)
    }
}

#Preview {
    ContentView()
}
