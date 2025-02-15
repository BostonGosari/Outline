//
//  CourseModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/15/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

protocol CourseModelProtocol {
    func readAllCourses(completion: @escaping (Result<[GPSArtCourse], GPSArtError>) -> Void)
    func readCourse(id: String, completion: @escaping (Result<GPSArtCourse, GPSArtError>) -> Void)
}

enum GPSArtError: Error {
    case dataNotFound
    case typeError
}

struct CourseModel: CourseModelProtocol {
    private let courseListRef = Firestore.firestore().collection("allGPSArtCourses")
    private let courseCategoryRef = Firestore.firestore().collection("artCategories")

    func readAllCourses(completion: @escaping (Result<[GPSArtCourse], GPSArtError>) -> Void) {
        courseListRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            do {
                var courseList: [GPSArtCourse] = []
                for snapshot in snapshot.documents {
                    let course = try snapshot.data(as: GPSArtCourse.self)
                    courseList.append(course)
                }
                completion(.success(courseList))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
    
    func readCourse(id: String, completion: @escaping (Result<GPSArtCourse, GPSArtError>) -> Void) {
        courseListRef.document(id).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let courseInfo = try snapshot.data(as: GPSArtCourse.self)
                completion(.success(courseInfo))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
    
    func readAllCategories(completion: @escaping (Result<[CourseCategory], GPSArtError>) -> Void) {
        courseCategoryRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            do {
                var courseCategories: [CourseCategory] = []
                for snapshot in snapshot.documents {
                    let courseCategory = try snapshot.data(as: CourseCategory.self)
                    courseCategories.append(courseCategory)
                }
                completion(.success(courseCategories))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
    
    func readCategoryCourse(categoryType: CourseCategoryType, completion: @escaping (Result<CourseCategory, GPSArtError>) -> Void) {
        var categoryId: String = ""
        switch categoryType {
        case .category1:
            categoryId = "GPSArtHome_Category1"
        case .category2:
            categoryId = "GPSArtHome_Category2"
        case .category3:
            categoryId = "GPSArtHome_Category3"
        }
        courseCategoryRef.document(categoryId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let courseCategory = try snapshot.data(as: CourseCategory.self)
                completion(.success(courseCategory))
            } catch {
                completion(.failure(.typeError))
            }
        }
    }
}

/// async-await 
extension CourseModel {
    func readAllCourses() async throws -> [GPSArtCourse] {
        return try await withCheckedThrowingContinuation { coninuation in
            courseListRef.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    coninuation.resume(throwing: CoreDataError.dataNotFound)
                    return
                }
                do {
                    var courseList: [GPSArtCourse] = []
                    for snapshot in snapshot.documents {
                        let course = try snapshot.data(as: GPSArtCourse.self)
                        courseList.append(course)
                    }
                    coninuation.resume(returning: courseList)
                } catch {
                    coninuation.resume(throwing: CoreDataError.dataNotFound)
                }
            }
        }
    }

    func readAllCategories() async throws -> [CourseCategory] {
        return try await withCheckedThrowingContinuation { continuation in
            courseCategoryRef.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    continuation.resume(throwing: GPSArtError.dataNotFound)
                    return
                }
                do {
                    var courseCategories: [CourseCategory] = []
                    for snapshot in snapshot.documents {
                        let courseCategory = try snapshot.data(as: CourseCategory.self)
                        courseCategories.append(courseCategory)
                    }
                    continuation.resume(returning: courseCategories)
                } catch {
                    continuation.resume(throwing: GPSArtError.dataNotFound)
                }
            }
        }
    }

    func readCourse(id: String) async throws -> GPSArtCourse {
        return try await withCheckedThrowingContinuation { continuation in
            courseListRef.document(id).getDocument { (snapshot, error) in
                guard let snapshot = snapshot, snapshot.exists, error == nil else {
                    continuation.resume(throwing: GPSArtError.dataNotFound)
                    return
                }

                do {
                    let courseInfo = try snapshot.data(as: GPSArtCourse.self)
                    continuation.resume(returning: courseInfo)
                } catch {
                    continuation.resume(throwing: GPSArtError.typeError)
                }
            }
        }
    }

    func readCategoryCourse(categoryType: CourseCategoryType) async throws -> CourseCategory {
        return try await withCheckedThrowingContinuation { continuation in
            var categoryId: String = ""
            switch categoryType {
            case .category1:
                categoryId = "GPSArtHome_Category1"
            case .category2:
                categoryId = "GPSArtHome_Category2"
            case .category3:
                categoryId = "GPSArtHome_Category3"
            }
            courseCategoryRef.document(categoryId).getDocument { (snapshot, error) in
                guard let snapshot = snapshot, snapshot.exists, error == nil else {
                    continuation.resume(throwing: GPSArtError.dataNotFound)
                    return
                }

                do {
                    let courseCategory = try snapshot.data(as: CourseCategory.self)
                    continuation.resume(returning: courseCategory)
                } catch {
                    continuation.resume(throwing: GPSArtError.typeError)
                }
            }
        }
    }
}
