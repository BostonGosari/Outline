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
        KakaoSDK.initSDK(appKey: "NATIVE_APP_KEY")
    }
  
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
