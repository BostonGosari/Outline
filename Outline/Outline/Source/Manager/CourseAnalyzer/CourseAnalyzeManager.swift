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
    
    // 두 경로 간의 점의 갯수를 일치시키는 함수
    func makePointsEquallySpaced(path1: [CLLocationCoordinate2D], path2: [CLLocationCoordinate2D]) -> ([CLLocationCoordinate2D], [CLLocationCoordinate2D]) {
        let minPointsCount = min(path1.count, path2.count)
        var resultPath1 = [CLLocationCoordinate2D]()
        var resultPath2 = [CLLocationCoordinate2D]()

        for i in 0..<(minPointsCount - 1) {
            let guidePoint = path1[i]
            let closestUserPoint = findClosestPoint(guidePoint: guidePoint, userPath: path2)

            resultPath1.append(guidePoint)
            resultPath2.append(closestUserPoint)
        }

        // 마지막 점 추가
        resultPath1.append(path1.last!)
        resultPath2.append(path2.last!)

        return (resultPath1, resultPath2)
    }

    // 가이드 점에 가장 가까운 유저 점 찾기
    func findClosestPoint(guidePoint: CLLocationCoordinate2D, userPath: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        var closestPoint = userPath.first!
        var minDistance = Double.infinity

        for userPoint in userPath {
            let distance = calculateDistance(guidePoint, userPoint)
            if distance < minDistance {
                minDistance = distance
                closestPoint = userPoint
            }
        }

        return closestPoint
    }



    // 보간 함수
    private func interpolatePoint(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, factor: Double) -> CLLocationCoordinate2D {
        let latitude = start.latitude + (end.latitude - start.latitude) * factor
        let longitude = start.longitude + (end.longitude - start.longitude) * factor

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
