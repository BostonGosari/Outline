//
//  GPSArtHomeViewModel.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/19/23.
//

import CoreData
import CoreLocation
import CoreMotion
import SwiftUI

struct CourseWithDistance: Identifiable, Hashable {
    var id = UUID().uuidString
    var course: GPSArtCourse
    var distance: Double
}

class GPSArtHomeViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var courses: AllGPSArtCourses = []
    @Published var coursesForWatch: [GPSArtCourse] = []

    @Published var coursesWithDistance: [CourseWithDistance] = []
    @Published var recommendedCoures: [CourseWithDistance] = []
    
    @Published var firstCategoryTitle: String = ""
    @Published var secondCategoryTitle: String = ""
    @Published var thirdCategoryTitle: String = ""
    @Published var firstCourseList: [CourseWithDistance] = []
    @Published var secondCourseList: [CourseWithDistance] = []
    @Published var thirdCourseList: [CourseWithDistance] = []
    
    private let courseModel = CourseModel()
    private let locationManager = CLLocationManager()
    private let watchConnectivityManager = WatchConnectivityManager.shared
    
    override init() {
        super.init()
        locationManager.delegate = self    }
    
    func getAllCoursesFromFirebase() {
        courseModel.readAllCourses { result in
            switch result {
            case .success(let courseList):
                self.courses.removeAll()
                self.recommendedCoures.removeAll()
                self.coursesWithDistance.removeAll()
                self.firstCourseList.removeAll()
                self.secondCourseList.removeAll()
                self.thirdCourseList.removeAll()
                self.courses = courseList
                self.fetchRecommendedCourses()
                self.watchConnectivityManager.sendGPSArtCoursesToWatch(self.coursesForWatch)
                self.readFirstCourseList()
                self.readSecondCourseList()
                self.readThirdCourseList()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchRecommendedCourses() {
        let userlocation = locationManager.location?.coordinate
               
           if let location = userlocation {
               let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
               
               for course in self.courses {
                   guard let firstCoordinate = course.coursePaths.first else { continue }
                   let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                   let distance = currentCLLocation.distance(from: courseLocation)
                   coursesWithDistance.append(CourseWithDistance(course: course, distance: distance))
               }
               
              let sortedCoursesWithDistance = coursesWithDistance.sorted { $0.distance < $1.distance }
              
              self.recommendedCoures = Array(sortedCoursesWithDistance.prefix(3))
              
              coursesForWatch = sortedCoursesWithDistance.map { $0.course }
          } else {
              self.recommendedCoures = self.courses.prefix(3).map { CourseWithDistance(course: $0, distance: 0) }
              coursesForWatch = self.courses
          }
    }
    
    func readFirstCourseList() {
        courseModel.readCategoryCourse(categoryType: .category1) { result in
            switch result {
            case .success(let courseCategory):
                self.firstCategoryTitle = courseCategory.title
                if let location = self.locationManager.location?.coordinate {
                    let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    for courseId in courseCategory.courseIdList {
                        self.courseModel.readCourse(id: courseId) { resultOfReadingCourse in
                            switch resultOfReadingCourse {
                            case .success(let gpsArtCourseList):
                                if let firstCoordinate = gpsArtCourseList.coursePaths.first {
                                    let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                                    let distance = currentCLLocation.distance(from: courseLocation)
                                    self.firstCourseList.append(CourseWithDistance(course: gpsArtCourseList, distance: distance))
                                }
                            case .failure(let failure):
                                print("fail to read fire courseList \(failure)")
                            }
                        }
                    }
                } else {
                    // 위치 정보가 없을 경우
                    self.firstCourseList = self.courses.map { CourseWithDistance(course: $0, distance: 0) }
                }
            case .failure(let failure):
                print("fail to read category \(failure)")
            }
        }
    }

    
    func readSecondCourseList() {
        courseModel.readCategoryCourse(categoryType: .category2) { result in
            switch result {
            case .success(let courseCategory):
                self.secondCategoryTitle = courseCategory.title
                if let location = self.locationManager.location?.coordinate {
                    let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    for courseId in courseCategory.courseIdList {
                        self.courseModel.readCourse(id: courseId) { resultOfReadingCourse in
                            switch resultOfReadingCourse {
                            case .success(let gpsArtCourseList):
                                if let firstCoordinate = gpsArtCourseList.coursePaths.first {
                                    let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                                    let distance = currentCLLocation.distance(from: courseLocation)
                                    self.secondCourseList.append(CourseWithDistance(course: gpsArtCourseList, distance: distance))
                                }
                            case .failure(let failure):
                                print("fail to read fire courseList \(failure)")
                            }
                        }
                    }
                } else {
                    self.secondCourseList = self.courses.map { CourseWithDistance(course: $0, distance: 0) }
                }
            case .failure(let failure):
                print("fail to read category \(failure)")
            }
        }
    }
    
    func readThirdCourseList() {
        courseModel.readCategoryCourse(categoryType: .category3) { result in
            switch result {
            case .success(let courseCategory):
                self.thirdCategoryTitle = courseCategory.title
                if let location = self.locationManager.location?.coordinate {
                    let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    for courseId in courseCategory.courseIdList {
                        self.courseModel.readCourse(id: courseId) { resultOfReadingCourse in
                            switch resultOfReadingCourse {
                            case .success(let gpsArtCourseList):
                                if let firstCoordinate = gpsArtCourseList.coursePaths.first {
                                    let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                                    let distance = currentCLLocation.distance(from: courseLocation)
                                    self.thirdCourseList.append(CourseWithDistance(course: gpsArtCourseList, distance: distance))
                                }
                            case .failure(let failure):
                                print("fail to read fire courseList \(failure)")
                            }
                        }
                    }
                } else {
                    self.thirdCourseList = self.courses.map { CourseWithDistance(course: $0, distance: 0) }
                }
            case .failure(let failure):
                print("fail to read category \(failure)")
            }
        }
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
