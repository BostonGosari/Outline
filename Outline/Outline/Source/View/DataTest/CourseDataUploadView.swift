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
}

#Preview {
    CourseDataUploadView()
}
