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
        guard let kakaoAPIKey = Bundle.main.object(forInfoDictionaryKey: "KakaoAPIKey") as? String else { return }

        KakaoSDK.initSDK(appKey: kakaoAPIKey)
    }
  
    var body: some Scene {
        WindowGroup {
            ScoreTestView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
