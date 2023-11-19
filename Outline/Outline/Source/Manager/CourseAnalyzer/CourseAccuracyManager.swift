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

    override func calculate(userProgress: Double) {
        // 유저의 진행도가 100보다 작을 때 처리
        if userProgress < 100.0 {
            // 유저가 러닝을 마친 시점의 경로를 찾아내기
            let userLastPoint = userCourse.last!
            print(userLastPoint)
            var closestGuidePointIndex = 0
            var closestDistance = calculateDistance(userLastPoint, guideCourse[0])
            
            // 가이드 경로 중 가장 가까운 점 찾기
            for (index, guidePoint) in guideCourse.enumerated() {
                let distance = calculateDistance(userLastPoint, guidePoint)
                if distance < closestDistance {
                    closestDistance = distance
                    closestGuidePointIndex = index
                }
            }
            print("마지막점에서 가장 가까운 가이드 점 \(closestGuidePointIndex)")
            // 가이드 경로의 마지막으로부터 가장 가까운 점 이후의 경로 제거
            let remainingGuidePath = Array(guideCourse.prefix(upTo: closestGuidePointIndex + 1))
//            print("원래 가이드 \(guideCourse)")
//            print("제거한 배열 \(remainingGuidePath)")
//            print("유저가 뛴 배열 \(userCourse)")
            // 두 경로 간의 점의 갯수를 일치시키는 함수를 호출
            let (guideCourseWithEqualPoints, userCourseWithEqualPoints) = makePointsEquallySpaced(guideCourse: remainingGuidePath, userCourse: userCourse)
            print("가이드 길이 \(guideCourseWithEqualPoints.count), 유저 뛴 길이 \(userCourseWithEqualPoints.count)")
            // DTW 거리 계산
            let dtwDistance = getDynamicTimeWarpingDistance(guideCourseWithEqualPoints, userCourseWithEqualPoints)
            
            // 가이드 경로의 총 길이 계산
            let guideCourseLength =  calculateTotalCourseLength(guideCourseWithEqualPoints)
            print(dtwDistance)
            // 정확도 계산 (예: 전체 거리에 대한 가이드 경로 길이의 비율로 표현)
            let accuracy = 1.0 - min(1.0, (dtwDistance  / guideCourseLength))
            self.accuracy = accuracy  // 정확도를 클래스 변수에 저장
        } else {
            // 진행도가 100 이상이면 기존 로직 사용
            let (guideCourseWithEqualPoints, userCourseWithEqualPoints) = makePointsEquallySpaced(guideCourse: guideCourse, userCourse: userCourse)
            
            // DTW 거리 계산
            let dtwDistance = getDynamicTimeWarpingDistance(guideCourseWithEqualPoints, userCourseWithEqualPoints)
            
            // 가이드 경로의 총 길이 계산
            let guideCourseLength = calculateTotalCourseLength(guideCourseWithEqualPoints)
            
            // 정확도 계산 (예: 전체 거리에 대한 가이드 경로 길이의 비율로 표현)
            let accuracy = 1.0 - min(1.0, (dtwDistance  / guideCourseLength))
            print(dtwDistance)
            self.accuracy = accuracy  // 정확도를 클래스 변수에 저장
        }
    }
    
    // DTW 동적 시간 래핑
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
}
