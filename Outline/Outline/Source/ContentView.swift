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
    @State private var authState: AuthState = .onboarding
    var body: some View {
        Group {
            switch authState {
            case .onboarding:
                LoginView()
            case .logout:
                LoginView()
            case .lookAround:
                HomeTabView()
            case .login:
                HomeTabView()
            }
        }
        .onAppear {
            let authStateUserDefaults = UserDefaults.standard.string(forKey: "authState")
            self.authState = AuthState(rawValue: authStateUserDefaults ?? "onboarding") ?? .onboarding
        }
    }
}

#Preview {
    ContentView()
}
