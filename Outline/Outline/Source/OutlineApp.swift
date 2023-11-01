//
//  OutlineApp.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import CoreLocation
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth
import SwiftUI

@main
struct OutlineApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: "f5f877543f22328d2dfadcc5fdd05569")
    }
  
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
