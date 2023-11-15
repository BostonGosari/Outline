//
//  CourseProgressManager.swift
//  Outline
//
//  Created by hyunjun on 10/27/23.
//

import CoreLocation

class CourseProgressManager: CourseAnalyzeManager {
    private var progress: Double = 0.0
    
    func getProgress() -> Double {
        return progress
    }
    
//    override func calculate() {
//        let userCourseLength = calculateTotalCourseLength(userCourse)
//        let guideCourseLength = calculateTotalCourseLength(guideCourse)
//        
//        progress = (userCourseLength / guideCourseLength) * 100
//        progress = min(progress, 100)
//    }
    
    func calculateProgress(path1: [CLLocationCoordinate2D], path2: [CLLocationCoordinate2D]) {
        let guideCourseLength = calculateTotalCourseLength(path1)
        let userCourseLength = calculateTotalCourseLength(path2)
      
        print("경로 거리 : \(guideCourseLength), 유저가 뛴 거리 : \(userCourseLength)")
        
        progress = (userCourseLength / guideCourseLength) * 100
        print(progress)
        progress = min(progress, 100)
    } 
}
