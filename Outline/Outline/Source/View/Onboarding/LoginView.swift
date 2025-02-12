//
//  LoginView.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/12/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.routes) {
            InputNicknameView()
                .navigationDestination(for: LoginRoute.self) { route in
                    viewModel.loginView(type: route)
                }
        }
        .environmentObject(viewModel)
    }
}

