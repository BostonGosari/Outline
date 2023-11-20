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
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: []) var runningRecord: FetchedResults<CoreRunningRecord>
    
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
    
    func getScore(id: String) {
        
    }
    
    func deleteScore() {
        
    }
    
    private func saveContext() throws {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
}
