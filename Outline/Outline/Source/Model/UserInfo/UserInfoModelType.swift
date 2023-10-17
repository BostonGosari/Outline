//
//  UserInfoModelType.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
//

import SwiftUI

struct UserInfo: Hashable, Codable {
    var nickname: String
    var birthday: Date
    var height: Int
    var weight: Int
    var gender: Gender = .notSetted
}
enum Gender: String, Codable {
    case notSetted
    case man
    case woman
    case undefined
}
