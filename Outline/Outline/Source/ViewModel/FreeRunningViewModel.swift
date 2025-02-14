//
//  FreeRunningViewModel.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/14/25.
//

import SwiftUI

final class FreeRunningViewModel: ObservableObject {
    @AppStorage("authState") var authState: AuthState = .logout
    @Published var userLocation = ""
    @Published var progress: Double = 0.0
    @Published var showPermissionSheet = false
    @Published var isUnlocked = false
    @Published var permissionType: PermissionType = .health
    @Published var freeRunCount: Int = 0

    let connectivityManager = ConnectivityManager.shared
    let runningStartManager = RunningStartManager.shared

}
