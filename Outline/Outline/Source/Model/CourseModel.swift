//
//  CourseModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/15/23.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

protocol CourseModelProtocol {}

enum GPSArtError: Error {
    case noCourses
    case networkError
}

struct CourseModel: CourseModelProtocol {
    private let courseListRef = Firestore.firestore().collection("allGPSArtCourses")
    
    func readAllCourses(completion: @escaping (Result<AllGPSArtCourses, GPSArtError>) -> Void) {
        courseListRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.noCourses))
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
                completion(.failure(.networkError))
            }
        }
    }
    
    func readCourse(id: String, completion: @escaping (Result<GPSArtCourse, DecodingError>) -> Void) {
        courseListRef.document(id).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                print("not found")
                return
            }
            
            do {
                let courseInfo = try snapshot.data(as: GPSArtCourse.self)
                completion(.success(courseInfo))
            } catch {
                switch error {
                case DecodingError.valueNotFound(_, let context):
                    print(context)
                case DecodingError.dataCorrupted(let context):
                    print(context)
                case DecodingError.typeMismatch(_, let context):
                    print(context)
                case DecodingError.keyNotFound(_, let context):
                    print(context)
                default:
                    print("error")
                }
            }
        }
    }
}
