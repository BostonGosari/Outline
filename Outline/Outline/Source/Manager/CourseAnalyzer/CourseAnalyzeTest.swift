//
//  CourseAnalyzeTest.swift
//  Outline
//
//  Created by hyunjun on 10/27/23.
//

import SwiftUI
import CoreLocation

let guideCourse = [
    CLLocationCoordinate2D(latitude: 37.8324, longitude: -122.4795),
    CLLocationCoordinate2D(latitude: 37.8310, longitude: -122.4840),
    CLLocationCoordinate2D(latitude: 37.8280, longitude: -122.4860),
    CLLocationCoordinate2D(latitude: 37.8260, longitude: -122.4850),
    CLLocationCoordinate2D(latitude: 37.8240, longitude: -122.4840),
    CLLocationCoordinate2D(latitude: 37.8220, longitude: -122.4820),
    CLLocationCoordinate2D(latitude: 37.8200, longitude: -122.4800),
    CLLocationCoordinate2D(latitude: 37.8180, longitude: -122.4780),
    CLLocationCoordinate2D(latitude: 37.8160, longitude: -122.4760),
    CLLocationCoordinate2D(latitude: 37.8140, longitude: -122.4740),
    CLLocationCoordinate2D(latitude: 37.8120, longitude: -122.4720),
    CLLocationCoordinate2D(latitude: 37.8100, longitude: -122.4700),
    CLLocationCoordinate2D(latitude: 37.8080, longitude: -122.4680),
    CLLocationCoordinate2D(latitude: 37.8060, longitude: -122.4660),
    CLLocationCoordinate2D(latitude: 37.8040, longitude: -122.4640)
]

let userCourse = [
    CLLocationCoordinate2D(latitude: 37.8325, longitude: -122.4794),
    CLLocationCoordinate2D(latitude: 37.8311, longitude: -122.4839),
    CLLocationCoordinate2D(latitude: 37.8281, longitude: -122.4859),
    CLLocationCoordinate2D(latitude: 37.8261, longitude: -122.4849),
    CLLocationCoordinate2D(latitude: 37.8241, longitude: -122.4839),
    CLLocationCoordinate2D(latitude: 37.8221, longitude: -122.4819),
    CLLocationCoordinate2D(latitude: 37.8201, longitude: -122.4799),
    CLLocationCoordinate2D(latitude: 37.8181, longitude: -122.4779),
    CLLocationCoordinate2D(latitude: 37.8161, longitude: -122.4759),
    CLLocationCoordinate2D(latitude: 37.8141, longitude: -122.4739),
    CLLocationCoordinate2D(latitude: 37.8121, longitude: -122.4719),
    CLLocationCoordinate2D(latitude: 37.8101, longitude: -122.4699),
    CLLocationCoordinate2D(latitude: 37.8081, longitude: -122.4679),
    CLLocationCoordinate2D(latitude: 37.8061, longitude: -122.4659),
    CLLocationCoordinate2D(latitude: 37.8041, longitude: -122.4639)
]

struct CourseAnalyzeTest: View {
    
    @State private var accuracy: Double = 0
    @State private var progress: Double = 0
    
    var body: some View {
            VStack {
                Text("Course Analysis")
                    .font(.largeTitle)
                    .padding()

                ProgressView(value: progress, total: 100)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()

                Text("Progress: \(String(format: "%.2f", progress))%")
                    .padding()

                ProgressView(value: accuracy, total: 1)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()

                Text("Accuracy: \(String(format: "%.2f", accuracy * 100))%")
                    .padding()
                
                Button(action: calculateCourse) {
                    Text("Calculate")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        
        func calculateCourse() {
            // 정확도 계산
            let accuracyManager = CourseAccuracyManager(guideCourse: guideCourse, userCourse: userCourse)
            accuracyManager.calculate()
            self.accuracy = accuracyManager.getAccuracy()
            
            // 진행률 계산
            let progressManager = CourseProgressManager(guideCourse: guideCourse, userCourse: userCourse)
            progressManager.calculate()
            self.progress = progressManager.getProgress()
        }
}

#Preview {
    CourseAnalyzeTest()
}
