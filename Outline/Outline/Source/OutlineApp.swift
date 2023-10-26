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
            ShareMainView(homeTabViewModel: HomeTabViewModel(), runningData: ShareModel(courseName: "댕댕런", runningDate: "2022.10.23", runningRegion: "효자동", distance: "5.2km", cal: "400cal", pace: "5.5", bpm: "150bpm", time: "30분20초", userLocations: [
                CLLocationCoordinate2D(latitude: 36, longitude: 129),
                CLLocationCoordinate2D(latitude: 36.0214, longitude: 129.1),
                CLLocationCoordinate2D(latitude: 36.214, longitude: 129.1),
                CLLocationCoordinate2D(latitude: 36.4215, longitude: 129.6),
                CLLocationCoordinate2D(latitude: 36.35, longitude: 129.23),
                CLLocationCoordinate2D(latitude: 36.51, longitude: 129.555),
                CLLocationCoordinate2D(latitude: 36.55555, longitude: 129.21)
            ]))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
