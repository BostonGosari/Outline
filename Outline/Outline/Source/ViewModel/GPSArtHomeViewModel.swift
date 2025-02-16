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
    /// 전체 코스 정보
    @Published var courses: [GPSArtCourse] = []
    @Published var coursesForWatch: [GPSArtCourse] = []

    /// 코스 관련 정보
    @Published var coursesWithDistance: [CourseWithDistanceAndScore] = []
    @Published var recommendedCoures: [CourseWithDistanceAndScore] = []
    @Published var firstCategoryTitle: String = ""
    @Published var secondCategoryTitle: String = ""
    @Published var thirdCategoryTitle: String = ""
    @Published var firstCourseList: [CourseWithDistanceAndScore] = []
    @Published var secondCourseList: [CourseWithDistanceAndScore] = []
    @Published var thirdCourseList: [CourseWithDistanceAndScore] = []

    @Published var selectedCourse: CourseWithDistanceAndScore?
    @Published var matched = false

    /// 스크롤 대응을 위한 프로퍼티
    @Published var scrollOffset: CGFloat = 0
    @Published var scrollXOffset: CGFloat = 0

    /// BigCard 설정을 위한 index
    @Published var currentIndex: Int = 1

    /// 네트워크 에러 핸들링을 위한 프로퍼티
    @Published var loading = true
    @Published var showNetworkErrorView = false
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

    func getAllCoursesFromFirebase() {
        courseModel.readAllCourses { result in
            switch result {
            case .success(let courseList):
                self.courses = courseList
                self.setCourseWithDistance()
                self.setRecommendedCourses()
                self.sendCoursesToWatch()
                self.setDetailCourses()
            case .failure(let error):
                print(error)
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
}

private extension GPSArtHomeViewModel {
    func checkNetworkError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + maxLoadingTime) { [weak self] in
            if let loading = self?.loading, loading{
                self?.showNetworkErrorView = true
            }
        }
    }

    func sendCoursesToWatch() {
        coursesForWatch = coursesWithDistance.map { $0.course }
        ConnectivityManager.shared.sendGPSArtCourses(coursesForWatch)
    }

    /// 코스들을 모두 거리순으로 정렬하여 courseWithDistance를 설정합니다.
    func setCourseWithDistance() {
        var newCoursesWithDistance = [CourseWithDistanceAndScore]()
        for course in courses {
            let distance = getLocationDistance(course)
            let courseWithScore = CourseWithDistanceAndScore(course: course, distance: distance, score: 0)
            newCoursesWithDistance.append(courseWithScore)
        }
        self.coursesWithDistance = newCoursesWithDistance.sorted { $0.distance < $1.distance }
    }

    /// Update the recommended courses
    func setRecommendedCourses() {
        self.recommendedCoures = Array(coursesWithDistance.prefix(3))
    }

    /// course 정보를 받아서 현재 위치에서 course까지의 거리를 리턴합니다.
    func getLocationDistance(_ course: GPSArtCourse) -> CLLocationDistance {
        var distance: Double = 0
        let userLocation = locationManager.location?.coordinate
        guard let firstCoordinate = course.coursePaths.first else {
            return CLLocationDistance(distance)
        }
        let courseLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)

        if let location = userLocation {
            let currentCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            distance = currentCLLocation.distance(from: courseLocation)
            return CLLocationDistance(distance)
        } else {
            return CLLocationDistance(distance)
        }
    }


    /// 각 카테고리에 맞는 코스를 설정합니다.
    func setDetailCourses() {
        Task {
            do {
                if let first = try await getCourseList(category: .category1) {
                    DispatchQueue.main.sync {
                        self.firstCategoryTitle = first.0
                        self.firstCourseList = first.1
                    }
                }
                if let second = try await getCourseList(category: .category2) {
                    DispatchQueue.main.sync {
                        self.secondCategoryTitle = second.0
                        self.secondCourseList = second.1
                    }
                }
                if let third = try await getCourseList(category: .category3) {
                    DispatchQueue.main.sync {
                        self.thirdCategoryTitle = third.0
                        self.thirdCourseList = third.1
                    }
                }
            } catch {

            }
        }
    }

    /// 카테고리에 맞는 코스를 모두 가져와서 리턴합니다.
    func getCourseList(category: CourseCategoryType) async throws -> (String, [CourseWithDistanceAndScore])? {
        let course = try await courseModel.readCategoryCourse(categoryType: category)
        var courseList = [CourseWithDistanceAndScore]()
        for courseId in course.courseIdList {
            guard let courseInfo = try? await courseModel.readCourse(id: courseId) else {
                // 카테고리에는 있지만, 전체 코스에는 없는 데이터가 있으면 종료되는 것을 방지
                continue
            }
            let distance = getLocationDistance(courseInfo)
            let courseWithScore = CourseWithDistanceAndScore(course: courseInfo, distance: distance, score: 0)
            courseList.append(courseWithScore)
        }
        if courseList.count >= 5 {
            courseList = courseList.sorted(by: { (course1, course2) -> Bool in
                guard let index1 = course.courseIdList.firstIndex(of: course1.course.id),
                      let index2 = course.courseIdList.firstIndex(of: course2.course.id) else {
                    return false
                }
                return index1 < index2
            })
        }
        return (course.title, courseList)
    }

    private func requestMotionAccess() {
        let motionManager = CMMotionActivityManager()

        if CMMotionActivityManager.isActivityAvailable() {
            motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, _ in }
        }
    }
}
