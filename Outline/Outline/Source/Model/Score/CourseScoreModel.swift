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
    case failToDelete
}

struct CourseScoreModel {
    @FetchRequest (entity: CoreCourseScore.entity(), sortDescriptors: []) var courseScores: FetchedResults<CoreCourseScore>
    
    let persistenceController = PersistenceController.shared
    
    func createOrUpdateScore(courseId: String, score: Int, completion: @escaping (Result<Bool, CourseScoreError>) -> Void) {
        getScore(id: courseId) { result in
            switch result {
            case .success(let score):
                if score == -1 {
                    let newCourseScore = CoreCourseScore(context: persistenceController.container.viewContext)
                    newCourseScore.setValue(courseId, forKey: "courseId")
                    newCourseScore.setValue(score, forKey: "score")
                } else {
                    getAllScores { res in
                        switch res {
                        case .success(let coreCourseList):
                            for courseScore in coreCourseList {
                                if let scoreIdFineded = courseScore.courseId, scoreIdFineded == courseId {
                                    courseScore.setValue(max(Int(courseScore.score), score), forKey: "score")
                                }
                            }
                        case .failure(let failure):
                            print("fail to get all courses \(failure)")
                            completion(.failure(.dataNotFound))
                        }
                    }
                }
                do {
                    try saveContext()
                    completion(.success(true))
                } catch {
                    completion(.failure(.failToSave))
                }
            case .failure(let failure):
                print("fail to get score \(failure)")
            }
        }
    }
    
    func getScore(id: String, completion: @escaping (Result<Int, CourseScoreError>) -> Void) {
        var score: Int = -1
        
        getAllScores { res in
            switch res {
            case .success(let coreCourseList):
                for courseScore in coreCourseList {
                    if let courseId = courseScore.courseId, courseId == id {
                        score = max(Int(courseScore.score), score)
                    }
                }
                completion(.success(score))
            case .failure(let failure):
                print("failt to get all courses \(failure)")
                completion(.failure(.dataNotFound))
            }
        }
    }
    
    func getAllScores(completion: @escaping (Result<[CoreCourseScore], CourseScoreError>) -> Void) {
        let request = CoreCourseScore.fetchRequest()
        do {
            var coreCourseList = try persistenceController.container.viewContext.fetch(request)
            completion(.success(coreCourseList))
        } catch {
            print("fetch Person error: \(error)")
            completion(.failure(.dataNotFound))
        }
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
    
    func deleteScoreById(
        id: String,
        completion: @escaping (Result<Bool, CourseScoreError>) -> Void
    ) {
        getAllScores { res in
            switch res {
            case .success(let courseScoreList):
                for courseScore in courseScoreList {
                    if courseScore.courseId == id {
                        deleteScore(courseScore) { res in
                            print(res)
                        }
                    }
                }
                
                do {
                    try saveContext()
                    completion(.success(true))
                } catch {
                    completion(.failure(.failToSave))
                }
            case .failure(let failure):
                print("fail to delete by id \(failure)")
                completion(.failure(.failToDelete))
            }
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
