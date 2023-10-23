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
            ShareMainView(homeTabViewModel: HomeTabViewModel(), runningData: ShareModel(courseName: "댕댕런", runningDate: "2022년 10월", runningRegion: "세빛섬", distance: "10km", cal: "400cal", pace: "5분", bpm: "150bpm", time: "30분", userLocations: [
                CLLocationCoordinate2D(latitude: 37.5118066, longitude: 126.9943851),
                CLLocationCoordinate2D(latitude: 37.5118166, longitude: 126.9953951),
                CLLocationCoordinate2D(latitude: 37.5147866, longitude: 126.9953751),
                CLLocationCoordinate2D(latitude: 37.5137566, longitude: 126.9943751),
                CLLocationCoordinate2D(latitude: 37.5107566, longitude: 126.9943751),
                CLLocationCoordinate2D(latitude: 37.5027566, longitude: 126.9947751),
                CLLocationCoordinate2D(latitude: 37.5057566, longitude: 126.9941451),
                CLLocationCoordinate2D(latitude: 37.5017566, longitude: 126.9946751),
            ]))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
