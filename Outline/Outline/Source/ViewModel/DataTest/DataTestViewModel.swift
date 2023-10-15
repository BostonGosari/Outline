//
//  DataTestViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Foundation

class FirstoreManager: ObservableObject {
    let userModel = UserModel()
    
    func writeUserData(nickname: String) {
        let newUser = User(nickname: nickname, birthday: Date(), height: 180, weight: 70, imageURL: "url", records: [], currentRunningData: RunningData(currentTime: 10.0, currentLocation: 10.0, paceList: [], bpmList: []))
//        userModel.writeUserData(user: newUser)
    }
}
