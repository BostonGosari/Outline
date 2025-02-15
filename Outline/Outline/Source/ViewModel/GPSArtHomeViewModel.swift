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

struct CourseWithDistanceAndScore: Identifiable, Hashable {
    var id = UUID().uuidString
    var course: GPSArtCourse
    var distance: Double
    var score: Int
}

class GPSArtHomeViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var courses: [GPSArtCourse] = []
    @Published var coursesForWatch: [GPSArtCourse] = []

    @Published var coursesWithDistance: [CourseWithDistanceAndScore] = []
    @Published var recommendedCoures: [CourseWithDistanceAndScore] = []
    @Published var firstCategoryTitle: String = ""
    @Published var secondCategoryTitle: String = ""
    @Published var thirdCategoryTitle: String = ""
    @Published var firstCourseList: [CourseWithDistanceAndScore] = []
    @Published var secondCourseList: [CourseWithDistanceAndScore] = []
    @Published var thirdCourseList: [CourseWithDistanceAndScore] = []

    @Published var scrollOffset: CGFloat = 0
    @Published var scrollXOffset: CGFloat = 0

    @Published var currentIndex: Int = 1
    @Published var loading = true
    @Published var selectedCourse: CourseWithDistanceAndScore?
    @Published var showNetworkErrorView = false
    @Published var matched = false
    let maxLoadingTime: TimeInterval = 5

    private let courseScoreModel = CourseScoreModel()
    private let courseModel = CourseModel()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func onAppear() {
        checkLocationAuthorization()
        if courses.isEmpty {
            getAllCoursesFromFirebase()
        }
        checkNetworkError()
    }

    func checkNetworkError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + maxLoadingTime) { [weak self] in
            if let loading = self?.loading, loading{
                self?.showNetworkErrorView = true
            }
        }
    }

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
                self.sendCoursesToWatch()
                self.setDetailCourses()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendCoursesToWatch() {
        ConnectivityManager.shared.sendGPSArtCourses(coursesForWatch)
    }
    
    func fetchRecommendedCourses() {
        let userLocation = locationManager.location?.coordinate

        for course in courses {
            guard let firstCoordinate = course.coursePaths.first else { continue }
            let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
            var distance: Double = 0

            if let location = userLocation {
                let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                distance = currentCLLocation.distance(from: courseLocation)
            }

            let courseWithScore = CourseWithDistanceAndScore(course: course, distance: distance, score: 0)
            self.coursesWithDistance.append(courseWithScore)
        }

        // Sort the courses by distance
        coursesWithDistance.sort { $0.distance < $1.distance }

        // Update the recommended courses
        self.recommendedCoures = Array(coursesWithDistance.prefix(3))
        coursesForWatch = coursesWithDistance.map { $0.course }
    }

    func setDetailCourses() {
        getCourseList(category: .category1)
        getCourseList(category: .category2)
        getCourseList(category: .category3)
    }

    func getCourseList(category: CourseCategoryType) {
        courseModel.readCategoryCourse(categoryType: category) { result in
            switch result {
            case .success(let courseCategory):
                switch category {
                case .category1:
                    self.firstCategoryTitle = courseCategory.title
                case .category2:
                    self.secondCategoryTitle = courseCategory.title
                case .category3:
                    self.thirdCategoryTitle = courseCategory.title
                }
                for courseId in courseCategory.courseIdList {
                    self.courseModel.readCourse(id: courseId) { resultOfReadingCourse in
                        switch resultOfReadingCourse {
                        case .success(let gpsArtCourseList):
                            // Fetch the score for the course
                            let userLocation = self.locationManager.location?.coordinate
                            let courseWithScore: CourseWithDistanceAndScore

                            if let firstCoordinate = gpsArtCourseList.coursePaths.first, let location = userLocation {
                                let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
                                let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                                let distance = currentCLLocation.distance(from: courseLocation)
                                courseWithScore = CourseWithDistanceAndScore(course: gpsArtCourseList, distance: distance, score: 0)
                            } else {
                                // If location is not available, set distance to 0
                                courseWithScore = CourseWithDistanceAndScore(course: gpsArtCourseList, distance: 0, score: 0)
                            }
                            switch category {
                            case .category1:
                                self.firstCourseList.append(courseWithScore)
                                if self.firstCourseList.count == 5 {
                                    let sortedCourseWithScores = self.firstCourseList.sorted(by: { (course1, course2) -> Bool in
                                        guard let index1 = courseCategory.courseIdList.firstIndex(of: course1.course.id),
                                              let index2 = courseCategory.courseIdList.firstIndex(of: course2.course.id) else {
                                            return false
                                        }
                                        return index1 < index2
                                    })
                                    self.firstCourseList = sortedCourseWithScores
                                }
                            case .category2:
                                self.secondCourseList.append(courseWithScore)
                                if self.secondCourseList.count == 5 {
                                    let sortedCourseWithScores = self.secondCourseList.sorted(by: { (course1, course2) -> Bool in
                                        guard let index1 = courseCategory.courseIdList.firstIndex(of: course1.course.id),
                                              let index2 = courseCategory.courseIdList.firstIndex(of: course2.course.id) else {
                                            return false
                                        }
                                        return index1 < index2
                                    })
                                    self.secondCourseList = sortedCourseWithScores
                                }
                            case .category3:
                                self.thirdCourseList.append(courseWithScore)
                                if self.thirdCourseList.count == 5 {
                                    let sortedCourseWithScores = self.thirdCourseList.sorted(by: { (course1, course2) -> Bool in
                                        guard let index1 = courseCategory.courseIdList.firstIndex(of: course1.course.id),
                                              let index2 = courseCategory.courseIdList.firstIndex(of: course2.course.id) else {
                                            return false
                                        }
                                        return index1 < index2
                                    })
                                    self.thirdCourseList = sortedCourseWithScores
                                }
                            }

                        case .failure(let failure):
                            print("fail to read fire courseList \(failure)")
                        }
                    }
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
