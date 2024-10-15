//
//  ScoreManager.swift
//  Outline
//
//  Created by 김하은 on 2/17/24.
//

import Foundation
import CoreLocation

class ScoreManager {
    let guideCourse: [CLLocationCoordinate2D]
    let userCourse: [CLLocationCoordinate2D]
    
    private(set) var score: Double = 0

    init(guideCourse: [CLLocationCoordinate2D], userCourse: [CLLocationCoordinate2D]) {
        self.guideCourse = guideCourse
        self.userCourse = userCourse
    }

    func calculate() {
        guard !userCourse.isEmpty else {
              self.score = 0
              return
          }
        
        // 가이드 코스와 유저 코스의 점 사이의 거리를 비교하여 똑같은 길이의 배열로 만들기
        let (guideCourseWithEqualPoints, userCourseWithEqualPoints) = makeEqualLengthCourses()

        // 새로운 배열을 이용하여 진행률 계산
        self.score = calculateScore(guideCourseWithEqualPoints, userCourseWithEqualPoints)
    }

    // 가이드 코스와 유저 코스의 각 점 사이의 거리를 비교하여 똑같은 길이의 배열로 만드는 메서드
    private func makeEqualLengthCourses() -> ([CLLocationCoordinate2D], [CLLocationCoordinate2D]) {
        var resultGuideCourse = [CLLocationCoordinate2D]()
        var resultUserCourse = [CLLocationCoordinate2D]()

        for guidePoint in guideCourse {
            // 가이드 코스의 각 점에 대해 유저 코스에서 가장 가까운 점 찾기
            let closestUserPoint = findClosestPoint(guidePoint: guidePoint, userPath: userCourse)
            // 가이드 코스의 각 점과 가장 가까운 유저 코스의 점 추가
            resultGuideCourse.append(guidePoint)
            resultUserCourse.append(closestUserPoint)
        }
        return (resultGuideCourse, resultUserCourse)
    }

    // 정확도를 계산하는 메서드
    private func calculateScore(_ guideCourse: [CLLocationCoordinate2D], _ userCourse: [CLLocationCoordinate2D]) -> Double {
        let totalPoints = guideCourse.count
        var matchedPoints : Double = 0

        for i in 0..<totalPoints {
            // 각 점 사이의 거리가 10미터 이내인 경우를 찾아 일치하는 점 개수 증가
            let distance = calculateDistance(guideCourse[i], userCourse[i])
            if distance <= 20 { // 완전일치
                matchedPoints += 1
            }
            else if distance <= 50 { // 부분 일치
                matchedPoints += 0.5
            }
            
        }

        // 전체 점 중 일치하는 점의 비율을 계산하여 진행률 반환
        return (Double(matchedPoints) / Double(totalPoints)) * 100
    }

    // 두 점 사이의 거리를 계산하는 메서드
    private func calculateDistance(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }

    // 가이드 코스의 각 점과 유저 코스에서 가장 가까운 점을 찾는 메서드
    private func findClosestPoint(guidePoint: CLLocationCoordinate2D, userPath: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        var closestPoint = userPath.first!
        var minDistance = calculateDistance(guidePoint, userPath.first!)

        for userPoint in userPath {
            let distance = calculateDistance(guidePoint, userPoint)
            if distance < minDistance {
                minDistance = distance
                closestPoint = userPoint
            }
        }

        return closestPoint
    }
}
