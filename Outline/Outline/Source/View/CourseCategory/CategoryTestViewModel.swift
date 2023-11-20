//
//  CategoryTestViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 11/19/23.
//

import SwiftUI

class CategoryTestViewModel: ObservableObject {
    @Published var firstCategoryTitle: String = ""
    @Published var secondCategoryTitle: String = ""
    @Published var thirdCategoryTitle: String = ""
    
    @Published var firstCourseList: [GPSArtCourse] = []
    @Published var secondCourseList: [GPSArtCourse] = []
    @Published var thirdCourseList: [GPSArtCourse] = []
    
    private let courseModel = CourseModel()
    
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
    }
}
