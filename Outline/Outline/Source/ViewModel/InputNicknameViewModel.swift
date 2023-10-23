//
//  InputNicknameViewModel.swift
//  Outline
//
//  Created by hyebin on 10/16/23.
//

import SwiftUI

class InputNicknameViewModel: ObservableObject {    
    @Published var nickname = ""
    @Published var checkInputCount = false
    @Published var checkInputWord = false
    @Published var checkNicnameDuplication = false
    @Published var moveToInputUserInfoView = false
    @Published var isSuccess = false
    
    @Published var defaultNickname = "아웃라인메이트"
    @Published var userNames = [String]()
    
    func checkNicname() {
        checkDuplication()
        checkCount()
        checkSymbol()
        
        isSuccess = checkInputCount && checkInputWord && checkNicnameDuplication
    }
    
    func doneButtonTapped() {
        if isSuccess {
            moveToInputUserInfoView = true
        }
    }
}

extension InputNicknameViewModel {
    private func checkDuplication() {
        if userNames.contains(nickname) {
            checkNicnameDuplication = false
        } else {
            checkNicnameDuplication = true
        }
    }
    
    private func checkCount() {
        checkInputCount = nickname.count >= 2 && nickname.count <= 16
    }
    
    private func checkSymbol() {
        let pattern = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]+$"
        checkInputWord = nickname.range(of: pattern, options: .regularExpression) != nil
    }
}
