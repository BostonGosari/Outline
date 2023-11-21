//
//  GPSArtHomeViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/19/23.
//

import CoreLocation
import CoreData
import SwiftUI
import CoreMotion

class GPSArtHomeViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var courses: AllGPSArtCourses = []
    @Published var recommendedCoures: [GPSArtCourse] = []
    @Published var firstCategoryTitle: String = ""
    @Published var secondCategoryTitle: String = ""
    @Published var thirdCategoryTitle: String = ""
    @Published var firstCourseList: [GPSArtCourse] = []
    @Published var secondCourseList: [GPSArtCourse] = []
    @Published var thirdCourseList: [GPSArtCourse] = []
    
    private let courseModel = CourseModel()
    private let locationManager = CLLocationManager()
    private let watchConnectivityManager = WatchConnectivityManager.shared
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getAllCoursesFromFirebase() {
        courseModel.readAllCourses { result in
            switch result {
            case .success(let courseList):
                self.courses = courseList
                self.watchConnectivityManager.sendGPSArtCoursesToWatch(self.courses)
                self.fetchRecommendedCourses()
                self.readFirstCourseList()
                self.readSecondCourseList()
                self.readThirdCourseList()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchRecommendedCourses() {
        guard let userLocation = locationManager.location?.coordinate else {
            // 위치 정보가 없을 경우 앞의 세 코스를 추천 코스로 표시하고 함수 종료
            self.recommendedCoures = Array(self.courses.prefix(3))
            return
        }
        
        let currentCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        // 각 코스의 거리를 계산하여 배열에 추가
        var courseDistances: [(course: GPSArtCourse, distance: Double)] = []
        
        for course in self.courses {
            guard let firstCoordinate = course.coursePaths.first else { continue }
            let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
            let distance = currentCLLocation.distance(from: courseLocation)
            courseDistances.append((course: course, distance: distance))
        }
        
        // 거리에 따라 배열을 정렬하고 가장 가까운 세 개의 코스를 선택
        let sortedCourses = courseDistances.sorted { $0.distance < $1.distance }
        self.recommendedCoures = sortedCourses.prefix(3).map { $0.course }
        print("fetchRecommendedCourses: \(self.recommendedCoures)")
    }
    
    func readFirstCourseList() {
        courseModel.readCategoryCourse(categoryType: .category1) { result in
            switch result {
            case .success(let courseCategory):
                self.firstCategoryTitle = courseCategory.title
                for courseId in courseCategory.courseIdList {
                    self.courseModel.readCourse(id: courseId) { resultOfReadingCourse in
                        switch resultOfReadingCourse {
                        case .success(let gpsArtCourseList):
                            self.firstCourseList.append(gpsArtCourseList)
                        case .failure(let failure):
                            print("fail to read fire courseList \(failure)")
                        }
                    }
                }
            case .failure(let failure):
                print("fail to read category \(failure)")
            }
        }
        print("firstCategoryTitle: \(self.firstCourseList)")
    }
    
    func readSecondCourseList() {
        courseModel.readCategoryCourse(categoryType: .category2) { result in
            switch result {
            case .success(let courseCategory):
                self.secondCategoryTitle = courseCategory.title
                for courseId in courseCategory.courseIdList {
                    self.courseModel.readCourse(id: courseId) { resultOfReadingCourse in
                        switch resultOfReadingCourse {
                        case .success(let gpsArtCourseList):
                            self.secondCourseList.append(gpsArtCourseList)
                        case .failure(let failure):
                            print("fail to read fire courseList \(failure)")
                        }
                    }
                }
            case .failure(let failure):
                print("fail to read category \(failure)")
            }
        }
        print("secondCategoryTitle: \(self.secondCourseList)")
    }
    
    func readThirdCourseList() {
        courseModel.readCategoryCourse(categoryType: .category3) { result in
            switch result {
            case .success(let courseCategory):
                self.thirdCategoryTitle = courseCategory.title
                for courseId in courseCategory.courseIdList {
                    self.courseModel.readCourse(id: courseId) { resultOfReadingCourse in
                        switch resultOfReadingCourse {
                        case .success(let gpsArtCourseList):
                            self.thirdCourseList.append(gpsArtCourseList)
                        case .failure(let failure):
                            print("fail to read fire courseList \(failure)")
                        }
                    }
                }
            case .failure(let failure):
                print("fail to read category \(failure)")
            }
        }
        print("thirdCategoryTitle: \(self.thirdCourseList)")
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            requestMotionAccess()
        case .authorizedAlways, .authorizedWhenInUse:
            requestMotionAccess()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    private func requestMotionAccess() {
        let motionManager = CMMotionActivityManager()
        
        if CMMotionActivityManager.isActivityAvailable() {
            motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, _ in }
        }
    }
}
