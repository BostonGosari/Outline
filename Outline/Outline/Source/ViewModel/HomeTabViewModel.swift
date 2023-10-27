//
//  GPSArtHomeViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/19/23.
//

import Foundation
import CoreLocation
import CoreData
import SwiftUI

struct CourseWithDistance: Identifiable {
    var id = UUID().uuidString
    var course: GPSArtCourse
    var distance: Double
}

class HomeTabViewModel: ObservableObject {
    
    @Published var courses: AllGPSArtCourses = []
    @Published var recommendedCoures: [CourseWithDistance] = []
    @Published var withoutRecommendedCourses: [CourseWithDistance] = []
    @Published var currentLocation: CLLocationCoordinate2D?
    
    @Published var userLocations = [CLLocationCoordinate2D]()

    let courseModel = CourseModel()
    let locationManager = CLLocationManager()
    let watchConnectivityManager = WatchConnectivityManager.shared
    
    func readAllCourses() {
        courseModel.readAllCourses { result in
            switch result {
            case .success(let courseList):
                self.courses = courseList
                self.watchConnectivityManager.sendGPSArtCoursesToWatch(self.courses)
                self.fetchRecommendedCourses()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchRecommendedCourses() {
        let userlocation = locationManager.location?.coordinate
        
        if let location = userlocation {
            let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            // 코스와 해당 거리를 함께 저장하는 배열
            var courseDistances: [CourseWithDistance] = []
            
            // 각 코스의 거리를 계산하여 배열에 추가
            for course in self.courses {
                guard let firstCoordinate = course.coursePaths.first else { continue }
                let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                let distance = currentCLLocation.distance(from: courseLocation)
                courseDistances.append(CourseWithDistance(course: course, distance: distance))
            }
            
            // 거리에 따라 배열을 정렬
            courseDistances.sort { $0.distance < $1.distance }
            
            // 가장 가까운 세 개의 코스와 그 외의 코스로 분리
            self.recommendedCoures = Array(courseDistances.prefix(3))
            self.withoutRecommendedCourses = Array(courseDistances.dropFirst(3))
        } else {
            // 위치 정보가 없을 경우 앞의 세 코스를 추천 코스로 표시하고 나머지는 추천되지 않은 코스로 표시
            self.recommendedCoures = self.courses.prefix(3).map { CourseWithDistance(course: $0, distance: 0) }
            self.withoutRecommendedCourses = Array(self.courses.dropFirst(3)).map { CourseWithDistance(course: $0, distance: 0) }
        }
    }
}
