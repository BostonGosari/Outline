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
    func readAllCourses(completion: @escaping (Result<AllGPSArtCourses, GPSArtError>) -> Void)
    func readCourse(id: String, completion: @escaping (Result<GPSArtCourse, GPSArtError>) -> Void)
}

enum GPSArtError: Error {
    case dataNotFound
    case typeError
}

struct CourseModel: CourseModelProtocol {
    private let courseListRef = Firestore.firestore().collection("allGPSArtCourses")
    
    func readAllCourses(completion: @escaping (Result<AllGPSArtCourses, GPSArtError>) -> Void) {
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
}
