//
//  CourseAnalyzeManager.swift
//  Outline
//
//  Created by hyunjun on 10/27/23.
//

import CoreLocation

class CourseAnalyzeManager {
    var guideCourse: [CLLocationCoordinate2D]
    var userCourse: [CLLocationCoordinate2D]
    
    init(guideCourse: [CLLocationCoordinate2D], userCourse: [CLLocationCoordinate2D]) {
        self.guideCourse = guideCourse
        self.userCourse = userCourse
    }
    
    func update(userCourse: [CLLocationCoordinate2D]) {
        self.userCourse = userCourse
        calculate()
    }
    
    func calculate() {
        fatalError("This method should be overridden")
    }
    
    func calculateDistance(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
    
    func calculateTotalCourseLength(_ course: [CLLocationCoordinate2D]) -> Double {
        var totalLength = 0.0
        if !course.isEmpty {
            for i in 1..<course.count {
                totalLength += calculateDistance(course[i-1], course[i])
            }
        }
        return totalLength
    }
}
