//
//  OutlineApp.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/13/23.
//

import Firebase
import CoreLocation
import SwiftUI

@main
struct OutlineApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
    }
  
    var body: some Scene {
        WindowGroup {
            ShareMainView(homeTabViewModel: HomeTabViewModel(), runningData: ShareModel(courseName: "댕댕런", runningDate: "", runningRegion: "", distance: "29KM", cal: "500cal", pace: "5'55", bpm: "150bpm", time: "2시간", userLocations: [
                CLLocationCoordinate2D(latitude: 36, longitude: 129),
                CLLocationCoordinate2D(latitude: 36.001, longitude: 129.004),
                CLLocationCoordinate2D(latitude: 36.003, longitude: 129.010),
                CLLocationCoordinate2D(latitude: 36.009, longitude: 129.001),
                CLLocationCoordinate2D(latitude: 35.990, longitude: 128.001),
                CLLocationCoordinate2D(latitude: 36.031, longitude: 129.304)
                
            ]))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
