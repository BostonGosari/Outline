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
    
    override func calculate() {
        let userCourseLength = calculateTotalCourseLength(userCourse)
        let guideCourseLength = calculateTotalCourseLength(guideCourse)
        
        progress = (userCourseLength / guideCourseLength) * 100
        progress = min(progress, 100)
    }
}
