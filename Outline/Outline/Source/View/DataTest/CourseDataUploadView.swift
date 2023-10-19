//
//  CourseDataUploadView.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import CoreLocation
import SwiftUI

struct CourseDataUploadView: View {
    private let coureDataUploadMananger = CourseDataUploadManager.shared
    private let parseManager = KMLParserManager()
    
    var body: some View {
        VStack {
            Button {
                let parsedCoordinates = parseCooridinates(fileName: "duckRun")
            } label: {
                Text("parseData")
            }
        }
    }
    
    func parseCooridinates(fileName: String) -> [CLLocationCoordinate2D] {
        if let kmlFilePath = Bundle.main.path(forResource: fileName, ofType: "kml") {
            let kmlParser = KMLParserManager()
            return kmlParser.parseKMLFile(atPath: kmlFilePath)
        }
        return []
    }
    
    func getPlaceMarks(coordinate: CLLocationCoordinate2D) -> Placemark? {
        let geocoder = CLGeocoder()
        var placemardResult: Placemark?
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                let area = placemark.administrativeArea ?? ""
                let city = placemark.locality ?? ""
                let town = placemark.subLocality ?? ""
                
                placemardResult = Placemark(
                    name: placemark.name ?? "",
                    isoCountryCode: placemark.isoCountryCode ?? "",
                    administrativeArea: placemark.administrativeArea ?? "",
                    subAdministrativeArea: placemark.subAdministrativeArea ?? "",
                    locality: placemark.locality ?? "",
                    subLocality: placemark.subLocality ?? "",
                    throughfare: placemark.thoroughfare ?? "",
                    subThroughfare: placemark.subThoroughfare ?? ""
                )
            }
        }
        
        return placemardResult
    }
}

#Preview {
    CourseDataUploadView()
}
