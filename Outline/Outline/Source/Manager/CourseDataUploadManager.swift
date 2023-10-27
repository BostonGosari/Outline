//
//  CourseDataUploadManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/19/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CourseDataUploadManager {
    static let shared = CourseDataUploadManager()
    private init() {}
    private let courseListRef = Firestore.firestore().collection("allGPSArtCourses")
    
    func uploadData(course: GPSArtCourse) {
        do {
            try courseListRef.document("\(course.id)").setData(from: course)
            print("success")
        } catch {
            print("fail to write")
        }
    }
    
}
