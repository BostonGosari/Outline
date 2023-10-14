//
//  OutlineApp.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import Firebase
import SwiftUI

@main
struct OutlineApp: App {
    @StateObject private var fireStoreManager = FireStoreManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fireStoreManager)
        }
    }
}
