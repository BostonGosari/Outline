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
enum Gender: String, Codable, CaseIterable {
    case notSetted = "설정 안 됨"
    case man = "남성"
    case woman = "여성"
    case undefined = "기타"
}

struct UserNameSet: Codable {
    var userNames: [String]
}
