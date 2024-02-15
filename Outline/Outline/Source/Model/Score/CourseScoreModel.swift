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
    @FetchRequest (entity: CoreRunningRecord.entity(), sortDescriptors: []) var runningRecord: FetchedResults<CoreRunningRecord>
    @FetchRequest (entity: CoreCourseScore.entity(), sortDescriptors: []) var courseScores: FetchedResults<CoreCourseScore>
    
    let persistenceController = PersistenceController.shared
    
    func createOrUpdateScore(courseId: String, score: Int, completion: @escaping (Result<Bool, CourseScoreError>) -> Void) {
        getScore(id: courseId) { result in
            switch result {
            case .success(let currentScore):
                let newScore: Int
                if currentScore == -1 {
                    // 스코어가 없는 경우 새로운 스코어를 추가합니다.
                    newScore = score
                } else {
                    // 이미 스코어가 있는 경우 주어진 값과 현재 스코어 중 큰 값을 선택합니다.
                    newScore = max(currentScore, score)
                }

                // 새로운 스코어를 저장합니다.
                let scoreEntity = CoreCourseScore(context: persistenceController.container.viewContext)
                scoreEntity.courseId = courseId
                scoreEntity.score = Int32(newScore)

                do {
                    try saveContext()
                    completion(.success(true))
                } catch {
                    completion(.failure(.failToSave))
                }
            case .failure(let failure):
                print("Failed to get score: \(failure)")
                completion(.failure(failure))
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
            let coreCourseList = try persistenceController.container.viewContext.fetch(request)
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
