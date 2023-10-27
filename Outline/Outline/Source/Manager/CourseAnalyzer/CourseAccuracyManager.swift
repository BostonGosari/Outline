//
//  CourseAccuracyManager.swift
//  Outline
//
//  Created by hyunjun on 10/27/23.
//

import CoreLocation

class CourseAccuracyManager: CourseAnalyzeManager {
    private var accuracy: Double = 0.0
    
    func getAccuracy() -> Double {
        return accuracy
    }
    
    override func calculate() {
        // DTW 거리
        let dtwDistance = getDynamicTimeWarpingDistance(guideCourse, userCourse)
        
        // Hausdorff 거리
        let hausdorffDistance = getHausdorffDistance(guideCourse, userCourse)
        
        // 가이드 경로의 총 길이 계산
        let totalGuideCourseLength = calculateTotalCourseLength(guideCourse)
        
        // 정확도 계산
        let distanceScore = dtwDistance / totalGuideCourseLength
        accuracy = 1 - distanceScore
        accuracy = max(0, min(1, accuracy))
    }

    // MARK: - DTW 동적 시간 래핑
    private func getDynamicTimeWarpingDistance(_ course1: [CLLocationCoordinate2D], _ course2: [CLLocationCoordinate2D]) -> Double {
        let n = course1.count
        let m = course2.count
        var dtwMatrix = Array(repeating: Array(repeating: Double.infinity, count: m), count: n)
        dtwMatrix[0][0] = 0
        
        for i in 1..<n {
            for j in 1..<m {
                let cost = calculateDistance(course1[i], course2[j])
                let minPrevious = min(dtwMatrix[i-1][j], dtwMatrix[i][j-1], dtwMatrix[i-1][j-1])
                dtwMatrix[i][j] = cost + minPrevious
            }
        }
        return dtwMatrix[n-1][m-1]
    }

    // MARK: - Hausdorff 거리
    private func getHausdorffDistance(_ course1: [CLLocationCoordinate2D], _ course2: [CLLocationCoordinate2D]) -> Double {
        let directedDistance1 = calculateHausdorffDistance(from: course1, to: course2)
        let directedDistance2 = calculateHausdorffDistance(from: course2, to: course1)
        return max(directedDistance1, directedDistance2)
    }

    private func calculateHausdorffDistance(from course1: [CLLocationCoordinate2D], to course2: [CLLocationCoordinate2D]) -> Double {
        var maxDistance = 0.0
        for point in course1 {
            let distances = course2.map { calculateDistance(point, $0) }
            let minDistance = distances.min() ?? 0.0
            maxDistance = max(maxDistance, minDistance)
        }
        return maxDistance
    }
}



