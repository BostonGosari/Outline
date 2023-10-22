//
//  ConnectingWatchModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/22/23.
//

import Foundation

struct ConnectingWatchModel {
    private let courseModel = CourseModel()
    
    func readCourses() {
        courseModel.readAllCourses { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
