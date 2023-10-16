//
//  InputNicknameViewModel.swift
//  Outline
//
//  Created by hyebin on 10/16/23.
//

import SwiftUI

enum NicnameState {
    case duplication
    case outOfCount
    case hasSymbol
    case success
    case input
}

class InputNicknameViewModel: ObservableObject {
    
    @Published var nickname = ""
    @Published var wrongLabel = ""
    @Published var currentState: NicnameState = .input

    let defaultNickname = "아웃라인메이트123"

    var wrongText: String {
        switch currentState {
        case .duplication:
            "이미 있는 닉네임이에요"
        case .outOfCount:
            "최소 2자 이상 16자 이하로 부탁드려요"
        case .hasSymbol:
            "특수문자를 지워주세요!"
        case .success:
            ""
        case .input:
            ""
        }
    }
    
    var checkImage: String {
        if currentState == .success {
            "checkmark.circle"
        } else {
            "x.circle"
        }
    }
    
    func checkNicname() {
        var newState: NicnameState = .success

        if !checkDuplication() {
            newState = .duplication
        } else if !checkCount() {
            newState = .outOfCount
        } else if !checkSymbol() {
            newState = .hasSymbol
        }

        currentState = newState
    }
    
    func doneButtonTapped() {
        if currentState == .success {
            /*moveTo InputUserInfoView*/
        }
    }
}

extension InputNicknameViewModel {
    private func checkDuplication() -> Bool {
        currentState = .duplication
        /*중복이면 false*/
        return true
    }
    
    private func checkCount() -> Bool {
        currentState = .outOfCount
        return nickname.count >= 2 && nickname.count <= 16
    }
    
    private func checkSymbol() -> Bool {
        let pattern = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]+$"
        return nickname.range(of: pattern, options: .regularExpression) != nil
    }
}
