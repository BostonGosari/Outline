//
//  InputNicknameViewModel.swift
//  Outline
//
//  Created by hyebin on 10/16/23.
//

import Combine
import SwiftUI

class InputNicknameViewModel: ObservableObject {    
    @Published var nickname = ""
    @Published var checkInputCount = false
    @Published var checkInputWord = false
    @Published var checkNicnameDuplication = false
    @Published var isSuccess = false
    @Published var moveToInputUserInfoView = false
    @Published  var isKeyboardVisible = false
    
    private var userNameSet: [String] = []
    
    var keyboardWillShowPublisher: AnyPublisher<Bool, Never> {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    var keyboardWillHidePublisher: AnyPublisher<Bool, Never> {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
            .eraseToAnyPublisher()
    }
    
    init() {
        let userInfoModel = UserInfoModel()
        userInfoModel.readUserNameSet { result in
            switch result {
            case .success(let userList):
                self.userNameSet = userList
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
        if userNameSet.contains(nickname) {
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
