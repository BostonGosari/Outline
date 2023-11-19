//
//  CourseCategoryModelType.swift
//  Outline
//
//  Created by Seungui Moon on 11/19/23.
//

#if os(iOS)
import Firebase
import FirebaseFirestoreSwift
#endif
import SwiftUI

typealias CourseCategories = [CourseCategory]

enum CourseCategoryType {
    case category1
    case category2
    case category3
}

struct CourseCategory: Codable, Hashable {
    var title: String
    var courseIdList: [String]
}
