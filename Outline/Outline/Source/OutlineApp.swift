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
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
    }

    private let workoutManager = WorkoutManager.shared
  
    var body: some Scene {
        WindowGroup {
            UserDataTestView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
