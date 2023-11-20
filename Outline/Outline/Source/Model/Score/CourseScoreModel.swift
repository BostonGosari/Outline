//
//  CourseScoreModel.swift
//  Outline
//
//  Created by Seungui Moon on 11/20/23.
//

import CoreData
import SwiftUI

enum CourseScoreError: Error {
    case typeError
    case dataNotFound
    case failToSave
}

struct CourseScoreModel {
    @FetchRequest (entity: CoreCourseScore.entity(), sortDescriptors: []) var courseScores: FetchedResults<CoreCourseScore>
    
    let persistenceController = PersistenceController.shared
    
    func createScore(courseId: String, score: Int, completion: @escaping (Result<Bool, CourseScoreError>) -> Void) {
        let newCourseScore = CoreCourseScore(context: persistenceController.container.viewContext)
        newCourseScore.setValue(courseId, forKey: "courseId")
        newCourseScore.setValue(score, forKey: "score")
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.failToSave))
        }
    }
    
    func getAllScores() {
        
    }
    
    func getScore(id: String) -> Int {
        var score: Int = -1
        for courseScore in courseScores {
            if let courseId = courseScore.courseId {
                score = max(Int(courseScore.score), score)
            }
        }
        return score
    }
    
    func deleteScore(
        _ object: NSManagedObject,
        completion: @escaping (Result<Bool, CourseScoreError>) -> Void
    ) {
        persistenceController.container.viewContext.delete(object)
        
        do {
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(.failToSave))
        }
    }
    
    private func saveContext() throws {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
}
