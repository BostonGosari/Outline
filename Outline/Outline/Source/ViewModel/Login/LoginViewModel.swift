//
//  File.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/12/25.
//

import Combine
import HealthKit
import SwiftUI

enum LoginRoute: Hashable {
    case inputName
    case healthAuth
    case inputUserInfo
}

final class LoginViewModel: ObservableObject {
    /// route 처리
    @Published var routes: [LoginRoute] = []

    @Published var nickname = ""
    @Published var checkInputCount = false
    @Published var checkInputWord = false
    @Published var checkNicnameDuplication = false
    @Published var isSuccess = false
    @Published var moveToInputUserInfoView = false
    @Published var moveToHeathAuthenticationView = false
    @Published  var isKeyboardVisible = false

    private var userNameSet: [String] = []
    private var healthStore = HKHealthStore()

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

    func createUserName() {
        let userInfoModel = UserInfoModel()
        if nickname.isEmpty {
            return
        }
        userInfoModel.createUserNameSet(userName: nickname) { res in
            switch res {
            case .success(let success):
                print("success to create userName \(success)")
            case .failure(let failure):
                print("fail to create userName \(failure)")
            }
        }
    }
}

extension LoginViewModel {
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

/// router 기능
extension LoginViewModel {
    @MainActor
    func push(screen: LoginRoute) {
        routes.append(screen)
    }

    @MainActor
    private func pop() {
        routes.removeLast()
    }

    @ViewBuilder
    func loginView(type: LoginRoute) -> some View {
        switch type {
        case .inputName:
            InputNicknameView()
        case .healthAuth:
            HealthAuthView()
        case .inputUserInfo:
            InputUserInfoView()
        }
    }
}

/// HealthKit 기능
extension LoginViewModel {

    func requestHealthAuthorization() {
        let quantityTypes: Set = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed),
            HKQuantityType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: quantityTypes, read: quantityTypes) {_, _ in
            DispatchQueue.main.async {
                self.push(screen: .inputUserInfo)
            }
        }
    }
}
