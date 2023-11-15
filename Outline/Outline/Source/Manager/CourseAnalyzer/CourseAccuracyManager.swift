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

    func calculateAccuracy(path1: [CLLocationCoordinate2D], path2: [CLLocationCoordinate2D], userProgress: Double) {
        // 유저의 진행도가 100보다 작을 때 처리
        if userProgress < 100.0 {
            // 유저가 러닝을 마친 시점의 경로를 찾아내기
            let userLastPoint = path2.last!
            print(userLastPoint)
            var closestGuidePointIndex = 0
            var closestDistance = calculateDistance(userLastPoint, path1[0])
            
            // 가이드 경로 중 가장 가까운 점 찾기
            for (index, guidePoint) in path1.enumerated() {
                let distance = calculateDistance(userLastPoint, guidePoint)
                if distance < closestDistance {
                    closestDistance = distance
                    closestGuidePointIndex = index
                }
            }
            print("마지막점에서 가장 가까운 가이드 점 \(closestGuidePointIndex)")
            // 가이드 경로의 마지막으로부터 가장 가까운 점 이후의 경로 제거
            let remainingGuidePath = Array(path1.prefix(upTo: closestGuidePointIndex + 1))
//            print("원래 가이드 \(path1)")
//            print("제거한 배열 \(remainingGuidePath)")
//            print("유저가 뛴 배열 \(path2)")
            // 두 경로 간의 점의 갯수를 일치시키는 함수를 호출
            let (path1WithEqualPoints, path2WithEqualPoints) = makePointsEquallySpaced(path1: remainingGuidePath, path2: path2)
            print("가이드 길이 \(path1WithEqualPoints.count), 유저 뛴 길이 \(path2WithEqualPoints.count)")
            // DTW 거리 계산
            let dtwDistance = getDynamicTimeWarpingDistance(path1WithEqualPoints, path2WithEqualPoints)
            
            // 가이드 경로의 총 길이 계산
            let guideCourseLength =  calculateTotalCourseLength(path1WithEqualPoints)
            print(dtwDistance)
            // 정확도 계산 (예: 전체 거리에 대한 가이드 경로 길이의 비율로 표현)
            let accuracy = 1.0 - min(1.0, (dtwDistance  / guideCourseLength))
            self.accuracy = accuracy  // 정확도를 클래스 변수에 저장
        } else {
            // 진행도가 100 이상이면 기존 로직 사용
            let (path1WithEqualPoints, path2WithEqualPoints) = makePointsEquallySpaced(path1: path1, path2: path2)
            
            // DTW 거리 계산
            let dtwDistance = getDynamicTimeWarpingDistance(path1WithEqualPoints, path2WithEqualPoints)
            
            // 가이드 경로의 총 길이 계산
            let guideCourseLength = calculateTotalCourseLength(path1WithEqualPoints)
            
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
